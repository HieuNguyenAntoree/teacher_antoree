import 'dart:async';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/models/timesheet.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/7.video/video_view.dart';
import 'package:ui_libraries/calendar/calendarro.dart';

class TimeSlotView extends StatelessWidget {
  const TimeSlotView();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TimeSlotView());
  }

  @override
  Widget build(BuildContext context) {
    String selectDateTime = VALUES.FORMAT_DATE_yyyy_mm_ddd.format(DateTime.now());
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
              create: (context) => APIConnect()..add(TimeSheetList(VALUES.FORMAT_DATE_API.format(DateTime.parse(selectDateTime)))),
              child: TimeSlotUI(),
            )
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

class TimeSlotUI extends StatefulWidget {
  const TimeSlotUI();
  @override
  TimeSlotUIState createState() => TimeSlotUIState();
}

class TimeSlotUIState extends State<TimeSlotUI>{

  bool _isLoading = false;
  List<String> timeSlots;
  int timelotsCount = 0;
  int indexSelected = -1;

  TimeSlotUIState();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        timeSlots = _caculatorTimeSlots(DateTime.now());
        timelotsCount = timeSlots.length;
      });
    });
  }

  String nextButton = IMAGES.CALENDAR_NEXT_UN;
  String backButton = IMAGES.CALENDAR_BACK_UN;
  DateTime _currentDate = DateTime.now().subtract(Duration(days: (DateTime.now().day - 1) ));
  DateTime _selectDate = DateTime.now();
  static final DateFormat formatMonth = DateFormat('MMMM | yyyy');
  String _currentMonth = formatMonth.format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  int currentDay = DateTime.now().day;
  Calendarro _calendarItem;
  List<TimeSheet> timeSheetList;

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
          actions: rightButton == "" ?
          <Widget>[
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
                _rightAction;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getTimeSheetWithTime(String time){
    DateTime currentTime = DateTime.parse(time);
    DateTime next20Time = DateTime.parse(time).add(new Duration(minutes: 20));
    timeSheetList = StorageUtil.getTimeSheetList();
    TimeSheet ts = timeSheetList.firstWhere((element) => element.timeStart.compareTo(currentTime) >= 0 && element.timeStart.compareTo(next20Time) < 0);
    if(ts.status == 3){
      return Color(0xffFF5600);
    }else if(ts.status == 4){
      return Color(0xffFF9900);
    }else if(ts.status == 1){
      return Color(0xff00C081);
    }else{
      return Colors.white;
    }
  }

  setTimeSheetConnectAPI(){

    setState(() {
      _isLoading = true;
    });
    String time = timeSlots[indexSelected] + ":00";
    String exdateTimeString = _selectDate.year.toString() + '-' + (_selectDate.month > 9 ? _selectDate.month.toString() : '0' + _selectDate.month.toString()) + '-'  + (_selectDate.day > 9 ? _selectDate.day.toString() : '0' + _selectDate.day.toString()) + ' '  + time;
    DateTime selectDateTime = DateTime.parse(exdateTimeString);

    DateFormat formatterAPI = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String startime = formatterAPI.format(selectDateTime);
    String endTime = formatterAPI.format(selectDateTime.add(new Duration(minutes: 20)));
    context.bloc<APIConnect>().add(SetTimeSheet(1, startime, endTime));
  }

  cancelTimeSheetConnectAPI(String time){
    setState(() {
      _isLoading = true;
    });
    DateTime currentTime = DateTime.parse(time);
    DateTime next20Time = DateTime.parse(time).add(new Duration(minutes: 20));
    TimeSheet ts = timeSheetList.firstWhere((element) => element.timeStart.compareTo(currentTime) >= 0 && element.timeStart.compareTo(next20Time) < 0);
    context.bloc<APIConnect>().add(CancelTimeSheet(ts.id));
  }

  getTimeLots(DateTime date){
    Future.delayed(Duration.zero, () {
      setState(() {
        timeSlots = _caculatorTimeSlots(date);
        timelotsCount = timeSlots.length;
      });
    });
  }

  List<String> _caculatorTimeSlots(DateTime date)
  {
    List<String> slots = List<String>();
    int difference = date.day - DateTime.now().day;
    if(difference > 0){
      int minute = 0;
      int hour = 5;
      int maxHour = 22;

      var i = hour;
      do{
        if (minute == 0){
          if(i + 1 > 9) {
            String str = i.toString() + ":00";
            slots.add(str);
          }else{
            String str = "0" + i.toString() + ":00";
            slots.add(str);
          }
          minute = VALUES.DELAY_TIME;
        }else if (minute != VALUES.DELAY_TIME){
          if(i > 9) {
            String str = (i).toString() + ":${2*VALUES.DELAY_TIME}";
            slots.add(str);
          }else{
            String str = "0" + (i).toString() + ":${2*VALUES.DELAY_TIME}";
            slots.add(str);
          }
          minute = 0;
          i++;
        }
        else{
          if(i > 9) {
            String str = (i).toString() + ":${VALUES.DELAY_TIME}";
            slots.add(str);
          }else{
            String str = "0" + (i).toString() + ":${VALUES.DELAY_TIME}";
            slots.add(str);
          }
          minute = 2*VALUES.DELAY_TIME;
        }
      }while(i <= maxHour);
      return slots;
    }else if (difference == 0){
      DateTime date = DateTime.now();
      int minute = date.minute > 2*VALUES.DELAY_TIME ? 0 : (date.minute > VALUES.DELAY_TIME ? 2*VALUES.DELAY_TIME : VALUES.DELAY_TIME);
      int hour = date.hour;
      int maxHour = 22;
      var i = (minute == 0 ? hour + 1 :hour);
      if(minute - date.minute < VALUES.DELAY_TIME){
        int ms = minute;
        minute = ms == 0 ? VALUES.DELAY_TIME : (ms == VALUES.DELAY_TIME ? 2*VALUES.DELAY_TIME : 0);
        i = (minute == 0 ? hour + 1 : (ms > 2*VALUES.DELAY_TIME ? hour + 1 : hour ));
      }

      do{
        if (minute == 0){
          if(i + 1 > 9) {
            String str = i.toString() + ":00";
            slots.add(str);
          }else{
            String str = "0" + i.toString() + ":00";
            slots.add(str);
          }
          minute = VALUES.DELAY_TIME;
        }else if (minute != VALUES.DELAY_TIME){
          if(i > 9) {
            String str = (i).toString() + ":${2*VALUES.DELAY_TIME}";
            slots.add(str);
          }else{
            String str = "0" + (i).toString() + ":${2*VALUES.DELAY_TIME}";
            slots.add(str);
          }
          minute = 0;
          i++;
        }
        else{
          if(i > 9) {
            String str = (i).toString() + ":${VALUES.DELAY_TIME}";
            slots.add(str);
          }else{
            String str = "0" + (i).toString() + ":${VALUES.DELAY_TIME}";
            slots.add(str);
          }
          minute = 2*VALUES.DELAY_TIME;
        }
      }while(i <= maxHour);
      return slots;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
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
            indexSelected = -1;
          });
        }else if (state.result is ParseJsonToObject) {
          setState(() {
            _isLoading = false;
          });
        }
        else {
          setState(() {
            _isLoading = false;
          });
          ErrorState error = state.result;
          if(error.msg == "Cancel"){
            _handleClickMe(STRINGS.ERROR_TITLE, "Time can't' cancel" , "Close", "", null);
          }else if(error.msg == "Set"){
            _handleClickMe(STRINGS.ERROR_TITLE, "Time can't' set", "Close", "", null);
          }else{
            _handleClickMe(STRINGS.ERROR_TITLE, error.msg, "Close", "", null);
          }
        }
      },
      child: LoadingOverlay(
        child: SingleChildScrollView(
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
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              SizedBox(height: 20,),
              _statusField(),
              SizedBox(height: 0,),
              _timelineField(),//
            ],
          ),
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
        displayMode: DisplayMode.WEEKS,
        selectedSingleDate: _selectDate,
        onPageSelected: (start_page, end_page) {
          print("onTap: $start_page");
          print("onTap: $end_page");
          setState(() {
            _currentMonth = DateFormat.yMMM().format(start_page);
          });
        },
        onTap: (date) {
          getTimeLots(date);
          this.setState(() => _selectDate = date);
        }

    );

    return _calendarItem;
  }

  _statusField(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _statusLabel(const Color(0xffff9900), 'Have meeting', 15, false),
              _statusLabel(const Color(0xff00c081), 'Available', 0, false)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _statusLabel(Colors.white, 'Unavailable', 15, true),
              _statusLabel(const Color(0xffff5600), 'Cancel by customer', 0, false)
            ],
          )
        ],
      ),
    );
  }

  _statusLabel(Color statusColor, String text, double leftPadding, bool border){
    return Container(
      padding: EdgeInsets.only(left: leftPadding),
      height: 50,
      width: MediaQuery.of(context).size.width/2,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !border ?
          Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(0),
              ),
              color: statusColor,
            ),
          ) :
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(0),
              ),
              border:  Border.all(width: 1.0, color: COLOR.COLOR_D8D8D8),
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10,),
          Text(
              text,
              style: const TextStyle(
                  color:  const Color(0xff4B5B53),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              ),
          )
        ],
      ),
    );
  }

  Color slotColor = Colors.white;
  _timelineField(){
    final double itemHeight = 40;
    final int total = timelotsCount;
    double maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 30 - 50 - 70 - 30 - kBottomNavigationBarHeight - 100 - 10;
    double girdHeight = (itemHeight * ((total/4).floor() + (total%4 > 0 ? 1 : 0)));
    double height = (girdHeight > maxHeight ? maxHeight : girdHeight) + 2;
    double width = MediaQuery.of(context).size.width;
    final double itemWidth = (width - 32)/4;
    final int gridViewCrossAxisCount = 4;

    return Container(
      height: height,
      margin: EdgeInsets.only(
        right: 15.0,
        left: 15.0,
      ),
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: gridViewCrossAxisCount,
        primary: false,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(total, (index) {
          return GestureDetector(
            onTap: () {
              if(indexMeeting == -1){
                setState(() {
                  indexSelected = index;
                  if(indexSelected == 1){
                    indexMeeting = 1;
                  }
                });
                setTimeSheetConnectAPI();
              }

            },
            child: Center(
              child: _timeItem(itemWidth, itemHeight, index, gridViewCrossAxisCount, total),

            ),
          );
        }),
      ),
    );
  }

  int indexMeeting = -1;
  _timeItem(double itemWidth, double itemHeight, int index, int count, int total){
    return Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: (indexSelected == index && indexMeeting != index) ? COLOR.COLOR_00C081 : getTimeSheetWithTime(timeSlots[index]),
          border: Border(
            top:  BorderSide(color: const Color(0xffd8d8d8), width: 1),
            right: BorderSide(color: const Color(0xffd8d8d8), width: 1),
            left: BorderSide(color:  index % count == 0 ? const Color(0xffd8d8d8) : Colors.transparent, width: 1),
            bottom: BorderSide(
                color:  (total % count == 0 && index <= total - 1 && index >= total - 4)
                    || (total % count != 0 && index >= total - count  && index <= total - 1)
                    ? const Color(0xffd8d8d8) : Colors.transparent,
                width: 1
            ),
          ),
        ),
        child: (indexMeeting == index && indexSelected == indexMeeting) ? _timeMeetingItem(itemWidth, itemHeight,'') : _timeNormalItem(index),
    );
  }

  _timeNormalItem(int index){
    return Center(
      child: Text(
        timeSlots[index],
        style: TextStyle(
            color:  const Color(0xff4B5B53),
            fontWeight: FontWeight.w400,
            fontFamily: "Montserrat",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
      ),
    );
  }

  _timeMeetingItem(double itemWidth, double itemHeight, String idSchedule){
    return  Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
          color:  Colors.white
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _backButton(itemWidth/2 - 1, itemHeight),
          _callButton(itemWidth/2 - 1, itemHeight, idSchedule),
        ],
      ),
    );
  }

  _callButton(double widthButton, double height, String idSchedule){
    return GestureDetector(
        onTap: () {
          context.bloc<APIConnect>().add(CallVideo(idSchedule,  "teacher"));
           VideoState(context, idSchedule).initState() ;
        },
        child: Container(
          width: widthButton,
          alignment: Alignment.center,
          height: height,
          decoration: BoxDecoration(
              color:  const Color(0xffff9900)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                IMAGES.CALENDAR_CALL_ACTIVE,
                width: 19.0,
                height: 19.0,
              ),
            ],
          ),
        )
    );
  }

  _backButton(double widthButton, double height){
    return GestureDetector(
      onTap: () {
        setState(() {
          indexSelected = -1;
          indexMeeting = -1;
        });
      },
      child: Container(
        width: widthButton,
        alignment: Alignment.center,
        height: height,
        decoration: BoxDecoration(
            color:  Colors.white
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              IMAGES.CALENDAR_CALL_BACK,
              width: 26.0,
              height: 20.0,
            ),
          ],
        ),
      )
    );
  }

}