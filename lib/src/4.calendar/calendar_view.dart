import 'dart:async';

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
import 'package:teacher_antoree/src/customViews/route_names.dart';
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
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
            title:_customeHeaderBar(),
            leading: addLeadingIcon(context),
            centerTitle: true,
            backgroundColor: const Color(0xffffffff)
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: BlocProvider(
            create: (context) => APIConnect()..add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(DateTime.now()), VALUES.FORMAT_DATE_API.format(DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS))))),
            child: CalendarUI(this.idSchedule),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  addLeadingIcon(BuildContext context){
    return new Container(
      height: 30.0,
      width: 26.0,
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Image.asset(
            IMAGES.HOME_LOGOUT,
            width: 30.0,
            height: 26.0,
          ),
          new FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              }
          )
        ],
      ),
    );
  }
  _customeHeaderBar() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Image.asset(IMAGES.HOME_LOGO, width: 100, height: 18,),
            ),
          ),
          GestureDetector(
              child: Image.asset(IMAGES.HOME_NOTI_OFF, width: 41, height: 35,)
          ),
        ],
      ),
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
  String nextButton = IMAGES.CALENDAR_NEXT_UN;
  String backButton = IMAGES.CALENDAR_BACK_UN;
  DateTime _currentDate = DateTime.now().subtract(Duration(days: (DateTime.now().day - 1) ));
  DateTime _selectDate = DateTime.now();
  static final DateFormat formatMonth = DateFormat('MMMM | yyyy');
  String _currentMonth = formatMonth.format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  int currentDay = DateTime.now().day;
  Calendarro _calendarItem;
  bool _isCancel = false;
  bool isScrollEventList = false;

  double maxHeight = 0;
  List<Schedule> schedulesInDay = List<Schedule>();

  @override
  void initState() {
    super.initState();
    getSchedulesInDay();
  }

  getSchedulesInDay(){
    scheduleList = StorageUtil.getScheduleList();
    getScheduleDependToDate();
  }

  getDateFromAPI(){
    context.bloc<APIConnect>().add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(_selectDate), VALUES.FORMAT_DATE_API.format(_selectDate.add(new Duration(days: VALUES.SCHEDULE_DAYS)))));
  }

  Future<void> _handleClickMe(String title, String mess, String leftButton, String rightButton, Function _rightAction) async {
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
          actions: <Widget>[
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
            rightButton == "" ? SizedBox(width: 0,) : CupertinoDialogAction(
              child: Text(rightButton, style:
              const TextStyle(
                  color:  const Color(0xff4B5B53),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              ),),
              onPressed: () {
                _rightAction;
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
            _handleClickMe(STRINGS.ERROR_TITLE, error.msg, "Close", "Try again!", getDateFromAPI());
          }
        },
        child: LoadingOverlay(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
              _timeSheet(context), //
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
        displayMode: DisplayMode.MONTHS,
        selectedSingleDate: _selectDate,
        onPageSelected: (start_page, end_page) {
          print("onTap: $start_page");
          print("onTap: $end_page");
          setState(() {
            _currentMonth = DateFormat.yMMM().format(start_page);
          });
        },
        onTap: (date) {
          if(date.difference(DateTime.now()).inDays >= 0){
            this.setState(() {
              _selectDate = date;
              getSchedulesInDay();
            });
          }else{
            SnackBar(
              content: Text('Can not select previous day'),
            );
          }
        }

    );

    return _calendarItem;
  }

  _timeSheet(BuildContext context){

    maxHeight = MediaQuery.of(context).size.height - kToolbarHeight  - kBottomNavigationBarHeight - 10 - 320 - 55;
    return schedulesInDay.length == 0 ? SizedBox(height: 0,) : Container(
      height:schedulesInDay.length == 0 ?  0: maxHeight,
      child: ListView.builder(
        itemBuilder: (context, int index) {
          return  TimeSheetItem(scheduleItem: schedulesInDay[index], cancelAction: cancelAction, isCurrentDay: checkCurrentDay(),);
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        itemCount: schedulesInDay.length,
//        controller: _scrollController,
      ),
    );
  }

  getScheduleDependToDate(){
    schedulesInDay.clear();
    for (var i = 0; i < scheduleList.objects.length; i++) {
      DateTime dateSchedule = scheduleList.objects[i].date;
      int days =  _selectDate.difference(dateSchedule).inDays;
      if(days == 0 && _selectDate.day - dateSchedule.day == 0) {
        for(Schedule sch in scheduleList.objects[i].schedules){
          List<User> users = sch.users;
          User student = users.firstWhere((element) => element.role == "student");
          if(student != null){
            schedulesInDay.add(sch);
          }
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int checkCurrentDay(){
    int days =  _selectDate.difference(DateTime.now()).inDays;
    if(days == 0){
      if(_selectDate.day - DateTime.now().day == 0) {
        return 0;
      }else{
        return 1;
      }
    }else if(days > 0){
      return 1;
    } else{
      return -1;
    }
  }
  cancelAction(value){
    setState(() {
      _isCancel = value;
    });
    context.bloc<APIConnect>().add(CancelSchedule( this.idSchedule, '', ''));
  }
  cancelSchedule(index){
    setState(() {
      Schedule sche = schedulesInDay[index];
      sche.status = SCHEDULE_STATUS.CANCEL;
    });
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
  final Schedule scheduleItem;
  final Function cancelAction;
  final isCurrentDay;

  TimeSheetItem({Key key, this.scheduleItem, this.cancelAction, this.isCurrentDay})
      : super(key: key);

  @override
  TimeSheetItemState createState() => TimeSheetItemState(this.scheduleItem, this.cancelAction, this.isCurrentDay);

}

class TimeSheetItemState extends State<TimeSheetItem> {

  TimeSheetItemState(this.scheduleItem, this.cancelAction, this.isCurrentDay);

  double widthCell = 0;
  Function cancelAction;
  int isCurrentDay;
  Timer timer;
  int isOnTime = 1;
  int delayTime = 14;
  Schedule scheduleItem;

  @override
  void initState() {
    super.initState();
    _checkOnTime();
    if(isCurrentDay == 0 && isOnTime >= 0) {
      timer = Timer.periodic(Duration(minutes: delayTime), (Timer t) => _checkOnTime());
    }
  }

  //Function
  _checkOnTime(){
    DateTime date = scheduleItem.startTime;
    int ms = date.difference(DateTime.now()).inMinutes;
    if(ms >= -delayTime && ms <= delayTime){
      setState(() {
          isOnTime = 0;
      });
    }else  if(ms < -delayTime){
      setState(() {
        isOnTime = -1;
        if (timer != null){
         timer.cancel();
        }
      });
    }else{
      isOnTime = 1;
    }
  }

  String _getHourAndMinutes(){
    int start = 9;
    String hours = scheduleItem.startTime.hour > 9 ? scheduleItem.startTime.hour.toString() : "0" + scheduleItem.startTime.hour.toString();
    String minutes = scheduleItem.startTime.minute > 9 ? scheduleItem.startTime.minute.toString() : "0" + scheduleItem.startTime.minute.toString();
    return hours + ':' + minutes;
  }

  String scheduleStatus(){
    if(scheduleItem.status == SCHEDULE_STATUS.CANCEL){
      return SCHEDULE_STATUS_TEXT.CANCEL;
    }else if(scheduleItem.status == SCHEDULE_STATUS.DONE){
      return SCHEDULE_STATUS_TEXT.DONE;
    }else if(scheduleItem.status == SCHEDULE_STATUS.ACTIVE){
      return "";
    }else{
      return SCHEDULE_STATUS_TEXT.UNKNOWN;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = scheduleItem.users;
    User student = users.firstWhere((element) => element.role == "student");
    Color textColor = (scheduleItem.status == SCHEDULE_STATUS.DONE || scheduleItem.status == SCHEDULE_STATUS.ACTIVE) ? const Color(0xff00c081) :
    (scheduleItem.status == SCHEDULE_STATUS.CANCEL ? const Color(0xffFF5600) : const Color(0xffFF9900));
    widthCell = MediaQuery
        .of(context)
        .size
        .width - 90;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
//            height: heightCell,
            child: isOnTime == 0 ? new Text(
                _getHourAndMinutes(),
                style: const TextStyle(
                    color:  Colors.red,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat",
                    fontStyle:  FontStyle.normal,
                    fontSize: 18.0
                )
            ) :
            new Text(
                _getHourAndMinutes(),
                style: const TextStyle(
                    color:  const Color(0xff4B5B53),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat",
                    fontStyle:  FontStyle.normal,
                    fontSize: 18.0
                )
            )

        ),
        Container(
          width: widthCell,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15, top: 12),
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffd8d8d8)
                    )
                ),
                student.lastName != null ? SizedBox(height: 10,) : SizedBox(height: 0,),
                new Text(
                  (student.lastName != null ? student.lastName : "") + " " + scheduleStatus(),
                    style: TextStyle(
                        color:  textColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                ),
                scheduleItem.comment != null ? SizedBox(height: 13,) : SizedBox(height: 10,),
                Container(
                  width: widthCell - 15,
                  child: new Text(
                      scheduleItem.comment != null ? scheduleItem.comment : "",
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
                ((isCurrentDay >= 0 && isOnTime >= 0) ||  scheduleItem.status != SCHEDULE_STATUS.ACTIVE)? _bottomButton(context, widthCell) : SizedBox(height: 0,),
              ],
            ),
        )
      ],
    );
  }

  _bottomButton(BuildContext context, double width){
    double widthButton = (width - 10 - 15)/2;
    return Container(
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
                      cancelAction(scheduleItem.id);
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
                      Navigator.popUntil(
                          context, ModalRoute.withName(HomeViewRoute));
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
