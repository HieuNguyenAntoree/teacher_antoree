import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:teacher_antoree/src/customViews/route_names.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_widget/calendar_widget.dart';
import 'dart:math';
class CalendarView extends StatelessWidget {
  final String idSchedule;
  const CalendarView(this.idSchedule);
  static Route route(String idSchedule) {
    return MaterialPageRoute<void>(builder: (_) => CalendarView(idSchedule));
  }

  static final DateFormat formatterAPI = DateFormat('yyyy-MM-dd');

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
            create: (context) => APIConnect()..add(ScheduleFetched(0,formatterAPI.format(DateTime.now()), formatterAPI.format(DateTime.now().add(new Duration(days: 7))))),
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

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    loadDataFromLocal();
  }

  void loadDataFromLocal(){
    scheduleList = StorageUtil.getScheduleList();
    users = getScheduleDependToDate();
  }
  static final DateFormat formatterAPI = DateFormat('yyyy-MM-dd');
  void getUsers(){
    setState(() {
      users = getScheduleDependToDate();
    });
    context.bloc<APIConnect>().add(ScheduleFetched(0,formatterAPI.format(DateTime.now()), formatterAPI.format(DateTime.now().add(new Duration(days: 7)))));
  }

  String nextButton = IMAGES.CALENDAR_NEXT_UN;
  String backButton = IMAGES.CALENDAR_BACK_UN;
  DateTime _currentDate = DateTime.now();
  DateTime _selectDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  bool _isCancel = false;
  bool isScrollEventList = false;

  double maxHeight = 0;
  double heightCalendar = 300;
  int currentDay = DateTime.now().day;
  List<Attendee> users = List<Attendee>();
  CalendarController _calendarController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<APIConnect, ApiState>(
        listener: (context, state){
          if (state.result is StateInit) {

          }else if (state.result is LoadingState) {

          }else if (state.result is ParseJsonToObject) {
            setState(() {
              loadDataFromLocal();
            });
          }else {

            ErrorState error = state.result;
            showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
          }
        },
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
                                    color: const Color(0xff4B5B53),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0
                                )
                            )),
                        GestureDetector(onTap: () =>
                        {
                          setState(() {
                            _targetDateTime = DateTime(
                                _targetDateTime.year, _targetDateTime.month - 1);
                            _currentMonth =
                                DateFormat.yMMM().format(_targetDateTime);
                            nextButton = IMAGES.CALENDAR_NEXT;
                            Timer(Duration(seconds: 1), () {
                              nextButton = IMAGES.CALENDAR_NEXT_UN;
                            }
                            );
                          }),
                        },
                          child: Container(
                            width: 52,
                            height: 50,
                            child: Image.asset(
                              nextButton, width: 52.0, height: 50.0,),
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(onTap: () =>
                        {
                          setState(() {
                            _targetDateTime = DateTime(
                                _targetDateTime.year, _targetDateTime.month + 1);
                            _currentMonth =
                                DateFormat.yMMM().format(_targetDateTime);
                            backButton = IMAGES.CALENDAR_BACK;
                            Timer(Duration(seconds: 1), () {
                              backButton = IMAGES.CALENDAR_BACK_UN;
                            }
                            );
                          }),
                        },
                          child: Container(
                            width: 52,
                            height: 50,
                            child: Image.asset(
                              backButton, width: 52.0, height: 50.0,),
                          ),
                        ),
                        SizedBox(width: 15,),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: _calendarView(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            _timeSheet(context), //
          ],
        )
    );
  }

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day): [
        new Event(
          date: new DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month, DateTime
              .now()
              .day),
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

  CalendarHighlighter highlighter = (DateTime dt) {
    // randomly generate a boolean list of length monthLength + 1 (because months start at 1)
    return List.generate(Calendar.monthLength(dt) + 1, (index) {
      return (Random().nextDouble() < 0.3);
    });
  };

  _calendarView()
  {
    return Calendar(
      width: MediaQuery.of(context).size.width - 32,
      onTapListener: (DateTime dt) {
        final snackbar = SnackBar(content: Text('Clicked ${dt.month}/${dt.day}/${dt.year}!'),);
        Scaffold.of(context).showSnackBar(snackbar);
      },
      highlighter: highlighter,
    );
  }
  _calendarField() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        _selectDate = date;
        getUsers();
        this.setState(() => _selectDate = date);
        events.forEach((event) => print(event.title));
      },
      weekFormat: isScrollEventList,
      markedDatesMap: _markedDateMap,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
          color: const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      height: heightCalendar,
      selectedDateTime: _selectDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      showHeader: false,
      todayTextStyle: TextStyle(
          color: const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      todayButtonColor: const Color(0xfff8f8f8),
      todayBorderColor: const Color(0xfff8f8f8),
      daysTextStyle: TextStyle(
          color: const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      nextDaysTextStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      selectedDayTextStyle: TextStyle(
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w700,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 3600)),
      maxSelectedDate: _currentDate.add(Duration(days: 3600)),
      prevDaysTextStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      inactiveDaysTextStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w700,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 14.0
      ),
      weekdayTextStyle: TextStyle(
          color: const Color(0xff4B5B53),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
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
  _timeSheet(BuildContext context){

    maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 5 - 300 - 40 - 30 - kBottomNavigationBarHeight;
    return users.length == 0 ? SizedBox(height: 0,) : Container(
      height:users.length == 0 ?  0: maxHeight,
      child: ListView.builder(
        itemBuilder: (context, int index) {
          //page = page + 1;
          return  TimeSheetItem(item: users[index], cancelAction: cancelAction, isCurrentDay: checkCurrentDay(), selectDate: _selectDate,);
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        itemCount: users.length,
//        controller: _scrollController,
      ),
    );
  }

  List<Attendee> getScheduleDependToDate(){
    List<Attendee> users = List<Attendee>();
    for (var i = 0; i < scheduleList.objects.length; i++) {
      DateTime dateSchedule = scheduleList.objects[i].dateTime;
      int days =  _selectDate.difference(dateSchedule).inDays;
      if(days == 0 && _selectDate.day - dateSchedule.day == 0) {
        for (var j = 0; i < scheduleList.objects[i].attendees.length; j++) {
          Attendee user = scheduleList.objects[i].attendees[j];
          if(user.role == RoleEnum.STUDENT){
              users.add(user);
          }
        }
        return users;
      }
    }
    return users;
  }

  @override
  void dispose() {
    _calendarController.dispose();
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
          child: Center(
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
              width: MediaQuery.of(context).size.width - 40,
              height: (48 * 2 + 20 + 80).toDouble(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40,),
                  new GestureDetector(
                    onTap: ()=> {launch("tel://21213123123"),},
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
                  SizedBox(height: 20,),
                  new GestureDetector(
                    onTap: ()=> {cancelAction(false)},
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
        )
    );
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
    context.bloc<APIConnect>().add(CancelSchedule( this.idSchedule, 'change_plan', ''));
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
  final DateTime selectDate;
  final Attendee item;
  final Function cancelAction;
  final isCurrentDay;

  TimeSheetItem({Key key, this.item, this.cancelAction, this.isCurrentDay, this.selectDate})
      : super(key: key);

  @override
  TimeSheetItemState createState() => TimeSheetItemState(this.item, this.cancelAction, this.isCurrentDay, this.selectDate);

}

class TimeSheetItemState extends State<TimeSheetItem> {

  TimeSheetItemState(this.item, this.cancelAction, this.isCurrentDay, this.selectDate);

//  double heightCell = (25 + 78 + 10 + 180).toDouble();
  double widthCell = 0;
  Attendee item;
  Function cancelAction;
  int isCurrentDay;
  Timer timer;
  int isOnTime = 1;
  int delayTime = 14;
  final DateTime selectDate;

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
    DateTime date = selectDate;
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
    String hours = selectDate.hour > 9 ? selectDate.hour.toString() : "0" + selectDate.hour.toString();
    String minutes = selectDate.minute > 9 ? selectDate.minute.toString() : "0" + selectDate.minute.toString();
    return hours + ':' + minutes;
  }

  @override
  Widget build(BuildContext context) {

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
                SizedBox(height: 10,),
                new Text(
                    item.user.lastName,
                    style: const TextStyle(
                        color:  const Color(0xff00c081),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    )
                ),
                SizedBox(height: 13,),
                Container(
                  width: widthCell - 15,
                  child: new Text(
                      item.user.firstName,
                      style: const TextStyle(
                          color:  const Color(0xff4B5B53),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      )
                  )
                ),
                SizedBox(height: 10,),
                (isCurrentDay >= 0 && isOnTime >= 0) ? _bottomButton(context, widthCell) : SizedBox(height: 0,),
              ],
            ),
        )
      ],

    );
  }

  _bottomButton(BuildContext context, double width){
    double widthButton = (width - 10 - 15)/2;
    return Column(
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
                  cancelAction(true);
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
                }else {
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
