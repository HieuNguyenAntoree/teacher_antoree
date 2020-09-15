import 'dart:async';

import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/9.teacher/teacher_list.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'flutter_time_picker_spinner.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
        this.currentMiddleIndex(), this.currentRightIndex());
  }
}


class ChangeView extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChangeView());
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
          child: ChangeUI(),
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

class ChangeUI extends StatefulWidget {
  @override
  ChangeUIState createState() => ChangeUIState();
}

class ChangeUIState extends State<ChangeUI>{

  bool _isLoading = false;
  APIConnect _apiConnect = APIConnect();
  List<String> timeSlots;
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    _apiConnect.init();
    listenConnectionResponse();

  }

  void listenConnectionResponse(){
    _apiConnect.hasConnectionResponse().listen((Result result) {
      if (result is LoadingState) {
        showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: result.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);

      } else if (result is SuccessState) {

        //Navigator.push(context, ProfilePage.route());
      } else {

        ErrorState error = result;
        showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
      }
    });
  }

  String nextButton = IMAGES.CALENDAR_NEXT_UN;
  String backButton = IMAGES.CALENDAR_BACK_UN;
  DateTime _currentDate = DateTime.now();
  DateTime _selectDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button

    return SingleChildScrollView(
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
                              _currentMonth,
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
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                          nextButton = IMAGES.CALENDAR_NEXT;
                          Timer(Duration(seconds: 1),(){
                            nextButton = IMAGES.CALENDAR_NEXT_UN;}
                          );
                        }),
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
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                          backButton = IMAGES.CALENDAR_BACK;
                          Timer(Duration(seconds: 1),(){
                            backButton = IMAGES.CALENDAR_BACK_UN;}
                          );
                        }),
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
                  child: _calendarField(),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          _timelineField(),//
          SizedBox(height: 15,),
          _okButton(),
        ],
      ),
    );
  }

  int currentDay = DateTime.now().day;

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
        new Event(
          date: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          dot: Container(
            width: 5,
            height: 5,
            decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    },
  );

  _calendarField(){
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        if(date.difference(DateTime.now()).inDays >= 0){
          this.setState(() => _selectDate = date);
          events.forEach((event) => print(event.title));
        }else{
          SnackBar(
            content: Text('Can not select previous day'),
          );
        }
      },
      markedDatesMap: _markedDateMap,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
          color:  const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      weekFormat: false,
      height: 300.0,
      selectedDateTime: _selectDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      showHeader: false,
      todayTextStyle: TextStyle(
          color:  const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      todayButtonColor: const Color(0xfff8f8f8),
      todayBorderColor: const Color(0xfff8f8f8),
      daysTextStyle: TextStyle(
          color:  const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      nextDaysTextStyle: TextStyle(
          color:  Colors.grey,
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      selectedDayTextStyle: TextStyle(
          color:  const Color(0xffffffff),
          fontWeight: FontWeight.w700,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
          color:  Colors.grey,
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      inactiveDaysTextStyle: TextStyle(
          color:  Colors.grey,
          fontWeight: FontWeight.w700,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      weekdayTextStyle: TextStyle(
          color:  const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle:  FontStyle.normal,
          fontSize: 14.0
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
  }

  Color slotColor = Colors.white;
  _timelineField(){
    final double itemHeight = 40;
    final int total = 3;
    double maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 30 - 50 - 300 - 40 - 30 - kBottomNavigationBarHeight;
    double girdHeight = (itemHeight * total);
    double height = (girdHeight > maxHeight ? maxHeight : girdHeight) + 2;


    return Container(
      height: height,
      margin: EdgeInsets.only(
        right: 15.0,
        left: 15.0,
      ),
      child: Center(
        child: new TimePickerSpinner(
          is24HourMode: true,
          normalTextStyle: TextStyle(
              color:  Colors.grey,
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle:  FontStyle.normal,
              fontSize: 16.0
          ),
            highlightedTextStyle: TextStyle(
                color:  const Color(0xff4B5B53),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle:  FontStyle.normal,
                fontSize: 16.0
            ),
          spacing: 100,
          itemHeight: 40,
          isForce2Digits: false,
          minutesInterval: 20,
          onTimeChange: (time) {
            setState(() {
              //_dateTime = time;
            });
          },
        ),
      )
    );
  }


  _okButton(){
    return Center(
      child: new GestureDetector(
        onTap: () {
//          if(indexSelected != -1) {
//            String time = timeSlots[indexSelected] + ":00";
//            String exdateTimeString = _selectDate.year.toString() + '-' + (_selectDate.month > 9 ? _selectDate.month.toString() : '0' + _selectDate.month.toString()) + '-'  + (_selectDate.day > 9 ? _selectDate.day.toString() : '0' + _selectDate.day.toString()) + ' '  + time;
//            DateTime dateTime = DateTime.parse(exdateTimeString);
//            Navigator.of(context).pop(dateTime);
//          }
          Navigator.of(context).push(TeacherListView.route());
        },
        child: Container(
          width: 182,
          alignment: Alignment.center,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(5),
            ),
            color: indexSelected != -1 ? COLOR.COLOR_00C081 : Colors.grey,
          ),
          child: Text("Tìm giáo viên",
            style: TextStyle(
                color: const Color(0xffffffff),
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold
            ),),
        ),
      ),
    );
  }
}