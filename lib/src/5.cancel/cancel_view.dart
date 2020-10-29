import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:io' show Platform;
import 'package:ui_libraries/calendar/calendarro.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarView extends StatelessWidget {
  final String idSchedule;
  const CalendarView(this.idSchedule);
  static Route route(String idSchedule) {
    return MaterialPageRoute<void>(builder: (_) => CalendarView(idSchedule));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: COLOR.BG_COLOR,
        appBar: AppBar(
          title:_customeHeaderBar(context),
          centerTitle: true,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: COLOR.BG_COLOR,
          automaticallyImplyLeading: false,
//          actions: [
//            IconButton(
//              icon: Image.asset(IMAGES.HOME_NOTI_OFF, width: 29, height: 25,),
//              onPressed: () {
//
//              },
//            ),
//          ],
          leading: IconButton(
            icon: Image.asset(IMAGES.BACK_ICON, width: 26, height: 20,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocProvider(
          create: (context) => APIConnect(context)..add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(DateTime.now()), VALUES.FORMAT_DATE_API.format(DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS))))),
          child: CalendarUI(this.idSchedule),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  _customeHeaderBar(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Image.asset(IMAGES.HOME_LOGO, width: 100, height: 18,),
        ),
      ],
    );
  }
}

class CalendarUI extends StatefulWidget {
  final String idSchedule;
  const CalendarUI(this.idSchedule);
  @override
  CalendarUIState createState() => CalendarUIState(this.idSchedule);
}

class CalendarUIState extends State<CalendarUI> {

  int indexSelected = 0;
  ScheduleModel scheduleList;
  String idSchedule;
  CalendarUIState(this.idSchedule);

  bool _isLoading = false;
  bool _isCancel = false;
  String nextButton = IMAGES.CALENDAR_NEXT_UN;
  String backButton = IMAGES.CALENDAR_BACK_UN;
  DateTime _currentDate = DateTime.now().subtract(Duration(days: (DateTime.now().day - 1) ));
  DateTime _selectDate = DateTime.now();
  static final DateFormat formatMonth = DateFormat('MMMM | yyyy');
  String _currentMonth = formatMonth.format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  int currentDay = DateTime.now().day;
  Calendarro _calendarItem;
  bool isScrollUp = false;
  final ScrollController _scrollController = ScrollController();

  double maxHeight = 0;
  List<Schedule> schedulesInDay = List<Schedule>();

  @override
  void initState() {
    super.initState();
    getSchedulesInDay();
  }

  getSchedulesInDay(){
    setState(() {
      scheduleList = StorageUtil.getScheduleList();
      getScheduleDependToDate();
    });

  }

  getDateFromAPI(){
    context.bloc<APIConnect>().add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(_selectDate), VALUES.FORMAT_DATE_API.format(_selectDate.add(new Duration(days: VALUES.SCHEDULE_DAYS)))));
  }

  int checkCurrentDay(){
    String now = VALUES.FORMAT_DATE_API.format(DateTime.now());
    String select = VALUES.FORMAT_DATE_API.format(_selectDate);
    int duration = DateTime.parse(select).compareTo(DateTime.parse(now));
    if(duration > 0){
      return 1;
    }else{
      return 0;
    }
  }
  cancelAction(value){
    setState(() {
      _isCancel = true;
    });
//    context.bloc<APIConnect>().add(CancelSchedule( this.idSchedule, '', ''));
  }

  Future<void> _handleClickMe(String title, String mess, String leftButton, String rightButton, VoidCallback _onTap) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title, style: const TextStyle(
              color:  const Color(0xff4B5B53),
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontStyle:  FontStyle.normal,
              fontSize: 14.0
          ),),
          content: Text(mess,
            style: const TextStyle(
                color:  const Color(0xff4B5B53),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle:  FontStyle.normal,
                fontSize: 12.0
            ),),
          actions: rightButton == "" ? <Widget>[
            CupertinoDialogAction(
              child: Text(leftButton, style:
              const TextStyle(
                  color:  const Color(0xff4B5B53),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )]
              : <Widget>[
            CupertinoDialogAction(
              child: Text(leftButton, style:
              const TextStyle(
                  color:  const Color(0xff4B5B53),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(rightButton, style:
              const TextStyle(
                  color:  const Color(0xff4B5B53),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              ),),
              onPressed: () {
                _onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<APIConnect, ApiState>(
        listener: (context, state){
          if (state.result is StateInit) {
            setState(() {
              _isLoading = false;
            });
          }else if (state.result is LoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state.result is SuccessState) {
            setState(() {
              _isLoading = false;
            });

          }else if (state.result is ParseJsonToObject) {
            setState(() {
              _isLoading = false;
            });
            setState(() {
              getSchedulesInDay();
            });
          }
          else {
            setState(() {
              _isLoading = false;
            });
            ErrorState error = state.result;
            _handleClickMe(STRINGS.ERROR_TITLE, error.msg, "Close", "", null);
          }
        },
        child: _isCancel ?
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(height: 1.0,color: COLOR.COLOR_D8D8D8,),
            ]
        )
            :

        LoadingOverlay(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 1.0,
                color: COLOR.COLOR_D8D8D8,
              ),
              Container(
                color: const Color(0xfff8f8f8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 15.0,
                        bottom: 15.0,
                        left: 15.0,
                      ),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                  '${_currentMonth[0].toUpperCase()}${_currentMonth.substring(1)}',
                                  style: const TextStyle(
                                      color:  const Color(0xff4B5B53),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Montserrat",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 18.0
                                  )
                              )),
                          GestureDetector(onTap: ()=>
                          {
                            setState(() {
                              _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month -1);
                              _currentMonth = formatMonth.format(_targetDateTime);
                              _currentDate = _targetDateTime;
                              nextButton = IMAGES.CALENDAR_NEXT;
                            }),

                            Timer(Duration(milliseconds: 200),(){
                              setState(() {
                                nextButton = IMAGES.CALENDAR_NEXT_UN;
                              });
                            })
                          },
                            child: Container(
                              width: 52,
                              height: 50,
                              child: Image.asset(nextButton, width: 52.0, height: 50.0,),
                            ),
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(onTap: ()=>
                          {
                            setState(() {
                              _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month +1);
                              _currentMonth = formatMonth.format(_targetDateTime);
                              _currentDate = _targetDateTime;
                              backButton = IMAGES.CALENDAR_BACK;
                            }),

                            Timer(Duration(milliseconds: 200),(){
                              setState(() {
                                backButton = IMAGES.CALENDAR_BACK_UN;
                              });
                            })
                          },
                            child: Container(
                              width: 52,
                              height: 50,
                              child: Image.asset(backButton, width: 52.0, height: 50.0,),
                            ),
                          ),
                          SizedBox(width: 15,),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: _calendar(),//_calendarField(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(child:  _timeSheet(context),)//
            ],
          ),
          isLoading: _isLoading,
          // demo of some additional parameters
          opacity: 0.2,
          progressIndicator: CircularProgressIndicator(),
        )
    );
  }

  _calendar(){
    _calendarItem = Calendarro(
        startDate:  _currentDate.subtract(Duration(days: 3600)),
        endDate: _currentDate.add(Duration(days: 3600)),
        displayMode: isScrollUp  ? DisplayMode.WEEKS : DisplayMode.MONTHS,
        selectedSingleDate: _selectDate,
        onPageSelected: (start_page, end_page) {
          print("onTap: $start_page");
          print("onTap: $end_page");
          setState(() {
            _currentMonth = formatMonth.format(start_page);
          });
        },
        onTap: (date) {
          this.setState(() {
            _selectDate = date;
            getSchedulesInDay();
          });
        }

    );

    return _calendarItem;
  }

  _timeSheet(BuildContext context){

//    maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 1 - 320 - 80 - 10 - (Platform.isAndroid ? kBottomNavigationBarHeight : 0);
    return
      NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            print('inside the onNotification');
            if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
              print('scrolled down');
//        setState(() {
////          isScrollUp = true;
////          maxHeight = MediaQuery.of(context).size.height - kToolbarHeight  - kBottomNavigationBarHeight - 10 - 70 - 55;
//        });
            } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
              print('scrolled up');
//        setState(() {
////          isScrollUp = false;
////          maxHeight = MediaQuery.of(context).size.height - kToolbarHeight  - kBottomNavigationBarHeight - 10 - 320 - 55;
//        });
            }
            return true;
          },
          child: Container(
//        height: maxHeight,
            child: ListView.builder(
              itemBuilder: (context, int index) {
                return new TimeSheetItem( cancelAction: cancelAction,  scheduleList: this.schedulesInDay, index: index,) ;
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: schedulesInDay.length ,
              controller: _scrollController,
            ),
          )
      );
  }

  getScheduleDependToDate(){

    schedulesInDay.clear();

    setState(() {
      for (var i = 0; i < scheduleList.objects.length; i++) {
        DateTime dateSchedule = scheduleList.objects[i].date;
        if(_selectDate.day == dateSchedule.day && _selectDate.month == dateSchedule.month && _selectDate.year == dateSchedule.year) {

          for(Schedule sch in scheduleList.objects[i].schedules){
            List<User> users = sch.users;
            User student = users.firstWhere((element) => element.role == "student");
            if(student != null){
              schedulesInDay.add(sch);
            }
          }
          schedulesInDay.sort((a, b) => a.startTime.compareTo(b.startTime));
          break;
        }
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  _cancelPopupView(){
    return GestureDetector(
        onTap: ()=>
        {
          setState(() {
            _isCancel = !_isCancel;
          }),
        },
        child: Container(
            color: const Color(0xffd8d8d8).withOpacity(0.9),
//          height:  MediaQuery.of(context).size.height - kToolbarHeight - 25 - kBottomNavigationBarHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(5),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new GestureDetector(
                    onTap: ()=> {
            launch("tel://18006806"),
                    },
                    child: Container(
                      width: 150,
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: COLOR.COLOR_00C081,
                      ),
                      child: Text('Call center',
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  new GestureDetector(
                    onTap: ()=> {},
                    child: Container(
                      width: 150,
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: Colors.white,
                        border: Border.all(
                            color: COLOR.COLOR_00C081,
                            width: 4
                        ),
                      ),
                      child: Text('back',
                        style: TextStyle(
                            color: COLOR.COLOR_00C081,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class TimeSheetItem extends StatefulWidget {

  final Function cancelAction;
  final int index;
  final List<Schedule> scheduleList;

  TimeSheetItem({Key key,  this.cancelAction,  this.scheduleList, this.index})
      : super(key: key);

  @override
  TimeSheetItemState createState() => TimeSheetItemState(this.cancelAction,  this.scheduleList, this.index);

}

class TimeSheetItemState extends State<TimeSheetItem> {

  TimeSheetItemState(this.cancelAction, this.scheduleList, this.index);

  double widthCell = 0;
  Function cancelAction;
  Timer timer;
  int delayTime = 14;
  int index = 0;
  List<Schedule> scheduleList = List<Schedule>();

  @override
  void initState() {
    super.initState();
  }

  //Function
  int _checkOnTime(DateTime startTime){
    String now = VALUES.FORMAT_DATE_API.format(DateTime.now());
    Duration duration = startTime.difference(DateTime.parse(now));
    int hrs = duration.inHours;
    if(hrs > 0){
      return 1;
    }else{
      int ms = duration.inMinutes;
      if(ms >= -delayTime && ms <= delayTime){
        return 0;
      }if(ms < -delayTime){
        return -1;
      }else{
        return 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Schedule item = scheduleList[index];
    List<User> users = item.users;
    User student = users.firstWhere((element) => element.role == "student");
    Color textColor = (item.status == SCHEDULE_STATUS.DONE || item.status == SCHEDULE_STATUS.ACTIVE) ? const Color(0xff00c081) :
    (item.status == SCHEDULE_STATUS.CANCEL ? const Color(0xffFF5600) : const Color(0xffFF9900));

    String now = VALUES.FORMAT_DATE_API.format(DateTime.now());
    String select = VALUES.FORMAT_DATE_API.format(item.startTime);
    int duration = DateTime.parse(select).compareTo(DateTime.parse(now));
    int isCurrentDay = 0;
    if(duration > 0){
      isCurrentDay = 1;
    }

    int isOnTime = 0;
    if(isCurrentDay > 0){
      isOnTime = 1;
    }else{
      Duration duration = item.startTime.difference(DateTime.parse(now));
      int hrs = duration.inHours;
      if(hrs > 0){
        isOnTime = 1;
      }else{
        int ms = duration.inMinutes;
        if(ms >= -delayTime && ms <= delayTime){
          isOnTime = 0;
        }if(ms < -delayTime){
          isOnTime = -1;
        }else{
          isOnTime = 1;
        }
      }
    }
    Color timeColor = (isOnTime == 0) ? const Color(0xffff5600) : ((item.status == SCHEDULE_STATUS.CANCEL) ? const  Color(0xffFF5600) : const Color(0xff4B5B53));

    String hours = item.startTime.hour > 9 ? item.startTime.hour.toString() : "0" + item.startTime.hour.toString();
    String minutes = item.startTime.minute > 9 ? item.startTime.minute.toString() : "0" + item.startTime.minute.toString();
    String timeString =hours + ':' + minutes;

    if(isCurrentDay == 0 && isOnTime >= 0) {
      timer = Timer.periodic(Duration(minutes: delayTime), (Timer t) => _checkOnTime(item.startTime));
    }

    String status = '';
    if(item.status == SCHEDULE_STATUS.CANCEL){
      status = SCHEDULE_STATUS_TEXT.CANCEL;
    }else if(item.status == SCHEDULE_STATUS.DONE){
      status = SCHEDULE_STATUS_TEXT.DONE;
    }else if(item.status == SCHEDULE_STATUS.ACTIVE){
      status = '';
    }else{
      status =  SCHEDULE_STATUS_TEXT.UNKNOWN;
    }

    widthCell = MediaQuery
        .of(context)
        .size
        .width - 90;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        new Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            width: 90,
            child: Text(
                timeString,
                style:  TextStyle(
                    color:  timeColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat",
                    fontStyle:  FontStyle.normal,
                    fontSize: 18.0
                )
            )

        ),
        new Container(
          width: widthCell,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              new Container(
                  margin: EdgeInsets.only(right: 15, top: 12),
                  height: 1,
                  decoration: BoxDecoration(
                      color: const Color(0xffd8d8d8)
                  )
              ),
              SizedBox(height: 10,),
              new Text(
                (student.lastName != null ? student.lastName : "") + " " + status,
                style: TextStyle(
                    color:  textColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle:  FontStyle.normal,
                    fontSize: 14.0
                ),
              ),
              item.comment != null ? SizedBox(height: 13,) : SizedBox(height: 10,),
              new Container(
                  width: widthCell - 15,
                  child: new Text(
                      item.comment != null ? item.comment : "",
                      style: const TextStyle(
                          color:  const Color(0xff4B5B53),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      )
                  )
              ),
//                SizedBox(height: 10,),
              ((isCurrentDay >= 0 && isOnTime >= 0) &&  item.status == SCHEDULE_STATUS.ACTIVE)? _bottomButton(context, widthCell, isOnTime, item, isCurrentDay) : SizedBox(height: 0,),
            ],
          ),
        )
      ],
    );
  }

  _bottomButton(BuildContext context, double width, int isOnTime, Schedule item, int isCurrentDay){
    double widthButton = (width - 10 - 15)/2;
    return new Container(
        margin: EdgeInsets.only( top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                new GestureDetector(
                  onTap: () {
                    if(isOnTime > 0) {
                      cancelAction(item.id);
                    }else {
                      showAlertDialog(context: context,
                          title: '',
                          message: "Can't cancel this time",
                          actions: [AlertDialogAction(isDefaultAction: true, label: 'OK')],
                          actionsOverflowDirection: VerticalDirection.up);
                    }
                  },
                  child: isCurrentDay > 0 ? _cancelGreenButton(widthButton) : (isOnTime == 0  ? _cancelGreyButton(widthButton) : _cancelGreenButton(widthButton)),
                ),
                SizedBox(width: 10,),
                new GestureDetector(
                  onTap: () {
                    if (isOnTime == 0) {

                    }else if (isOnTime > 0) {
                      showAlertDialog(context: context,
                          title: '',
                          message: "Can't call this time",
                          actions: [AlertDialogAction(isDefaultAction: true, label: 'OK')],
                          actionsOverflowDirection: VerticalDirection.up);
                    }
                  },
                  child: isOnTime > 0 ? _callGreyButton(widthButton) : _callGreenButton(widthButton),
                ),
              ],
            ),
            SizedBox(height: 15,),
          ],
        )
    );
  }

  _cancelGreenButton(double widthButton){
    return Container(
      width: widthButton,
      alignment: Alignment.center,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(5),
        ),
        border: Border.all(width: 4.0, color: COLOR.COLOR_00C081),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IMAGES.CALENDAR_CANCEL_ACTIVE,
            width: 24.0,
            height: 24.0,
          ),
          SizedBox(width: 5,),
          Text(
              "Cancel",
              style: const TextStyle(
                  color:  COLOR.COLOR_00C081,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.0
              )
          )
        ],
      ),
    );
  }

  _cancelGreyButton(double widthButton){
    return Container(
      width: widthButton,
      alignment: Alignment.center,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(5),
        ),
        border:  Border.all(width: 4.0, color: COLOR.COLOR_D8D8D8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IMAGES.CALENDAR_CANCEL_UNACTIVE,
            width: 24.0,
            height: 24.0,
          ),
          SizedBox(width: 5,),
          Text(
              "Cancel",
              style: const TextStyle(
                  color:  const Color(0xffd8d8d8),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.0
              )
          )
        ],
      ),
    );
  }

  _callGreyButton(double widthButton){
    return Container(
      width: widthButton,
      alignment: Alignment.center,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(5),
        ),
        border: Border.all(width: 4.0, color: COLOR.COLOR_D8D8D8),
        color:  Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IMAGES.CALENDAR_CALL_UNACTIVE,
            width: 24.0,
            height: 24.0,
          ),
        ],
      ),
    );
  }

  _callGreenButton(double widthButton){
    return Container(
      width: widthButton,
      alignment: Alignment.center,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(5),
        ),
        color:  COLOR.COLOR_00C081,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            IMAGES.CALENDAR_CALL_ACTIVE,
            width: 24.0,
            height: 24.0,
          ),
        ],
      ),
    );
  }
}
