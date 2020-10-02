import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/4.calendar/calendar_picker_view.dart';
import 'package:teacher_antoree/src/4.calendar/calendar_view.dart';
import 'package:teacher_antoree/src/7.video/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.name;
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
            title:_customeHeaderBar(),
            centerTitle: true,
            backgroundColor: const Color(0xffffffff)
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: BlocProvider(
            create: (context) => APIConnect()..add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(DateTime.now()), VALUES.FORMAT_DATE_API.format(DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS))))),
            child: HomeUI(),
          )
        ),
      ),
      onWillPop: () async {
        return false;
      },
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

class HomeUI extends StatefulWidget {
  @override
  HomeUIState createState() => HomeUIState();
}

class HomeUIState extends State<HomeUI> {

  bool _isLoading = false;
  bool _isStartVideoCall = false;
  ScheduleModel scheduleList;
  Schedule currentSchedule;
  User student;
  User teacher;

  Color leftbuttonColor = Color(0xffb6d6cb);
  Color rightbuttonColor = Color(0xffb6d6cb);

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int days = 0;
  Timer timer;
  DateTime timerDate;

  static final DateFormat formatDateForTimer = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat formatDateForUI = DateFormat('hh:mm a EEEE  dd | MM | yyyy');
  final interval = const Duration(seconds: 1);

  startTimeout([int milliseconds]) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);

        seconds = seconds - 1;
        if (hours == 0 && minutes == 0 && seconds == 0) {
          _isStartVideoCall = true;
          timer.cancel();
        } else if (seconds <= 0) {
          minutes = minutes - 1;
          if (minutes == 0) {
            hours = hours - 1;
            if (hours == 0) {
              minutes = 60;
              seconds = 60;
            } else if (hours < 0) {
              hours = 0;
              seconds = 60;
            }
          } else if (minutes < 0) {
            minutes = 0;
            seconds = 60;
          }else  {
            seconds = 60;
          }
        }
      });
    });
  }

  void calculatorDuration(String date) {
    DateTime dob = DateTime.parse(date);
    Duration dur = dob.difference(DateTime.now());
    int s = dur.inSeconds;
    if (s > 0) {
      hours = dur.inHours;
      minutes = dur.inMinutes - (days * 24 * 60) - (hours * 60);
      seconds = dur.inSeconds - (days * 24 * 60 * 60) - (hours * 60 * 60) -
          (minutes * 60);
    } else {
      days = 0;
      hours = 0;
      minutes = 0;
      seconds = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    loadDataFromLocal();
  }

  loadDataFromLocal(){
    _isStartVideoCall = false;
    scheduleList = StorageUtil.getScheduleList();
    if(scheduleList != null){
      if(scheduleList.objects.length > 0) {
        for(var i = 0; i < scheduleList.objects.length; i ++){
          List<Schedule> list = scheduleList.objects[i].schedules;
          if(list.length > 0){
            Schedule schMin = list[0];
            DateTime nowTime = DateTime.now();
            for(Schedule sch in list){
              DateTime schTime = sch.startTime;
              int minsNow =  schTime.difference(nowTime).inMinutes;
              int minsWithMinSch =  schMin.startTime.difference(nowTime).inMinutes;
              if(minsNow > 0 && minsNow < minsWithMinSch) {
                schMin = sch;
              }
            }
            if(schMin.startTime.difference(nowTime).inMinutes > 0){
              currentSchedule = schMin;
              timerDate = currentSchedule.startTime;
              if(timer != null){
                timer.cancel();
              }
              calculatorDuration(formatDateForTimer.format(timerDate));
              if (hours > 0 || minutes > 0 || seconds > 0) {
                startTimeout();
              }
              for(var j = 0; j < currentSchedule.users.length; j ++){
                User _user = currentSchedule.users[j];
                if(_user.role == "teacher"){
                  teacher = _user;
                }else if(_user.role == "student"){
                  student = _user;
                }
              }
            }

            break;
          }
        }
      }
    }
  }

  getScheduleListFromAPI(){
    APIConnect()..add(ScheduleFetched(0,VALUES.FORMAT_DATE_API.format(DateTime.now()), VALUES.FORMAT_DATE_API.format(DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS)))));
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
            )] :
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<APIConnect, ApiState>(
        listener: (context, state){
          if (state.result is StateInit) {
            setState(() {
              _isLoading = true;
            });
          }else if (state.result is LoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state.result is ParseJsonToObject) {
            setState(() {
              _isLoading = false;
            });
            scheduleList = StorageUtil.getScheduleList();
            if(scheduleList != null) {
              if (scheduleList.objects.length == 0) {
                _handleClickMe(STRINGS.ERROR_TITLE, STRINGS.EMPTY_LIST, "Close", "", null);
              }
            }
            setState(() {
              loadDataFromLocal();
            });

            if(currentSchedule == null){
              _handleClickMe(STRINGS.ERROR_TITLE, STRINGS.NO_SCHEDULE, 'OK', '', null);
            }
          }else {
            setState(() {
              _isLoading = false;
            });
            ErrorState error = state.result;
            _handleClickMe(STRINGS.ERROR_TITLE, error.msg, "Close", "Try again!", getScheduleListFromAPI());
          }
        },
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(padding: EdgeInsets.all(40)),
              _avatarImage(),
              SizedBox(height: 20),
              _helloUserText(),
              SizedBox(height: 40),
              _textTimeSheet('Còn'),
              SizedBox(height: 5),
              _timeDownField(),
              SizedBox(height: 5,),
              _textTimeSheet('đến giờ hẹn'),
              Expanded(child: Container()),
              _bottomButton(),
            ],
          ),
        )
    );
  }

  _avatarImage() {
    return Center(
        child: Container(
          height: 125,
          width: 137,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
              border: Border.all(width: 5.0, color: COLOR.COLOR_00C081),
              color: Colors.white,
              image: (teacher != null && teacher.avatar.url != null) ? new DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(teacher.avatar.url)
              ) : new DecorationImage(
                  fit: BoxFit.none, image: new AssetImage(IMAGES
                  .HOME_AVATAR), scale: 2)
          ),
        )
    );
  }

  _helloUserText() {
    String studentName = 'Xin chào bạn\n';
    String content1 = "Hiện tại bạn không có cuộc hẹn nào với giáo viên\n";
    String content2 = "";
    if(currentSchedule != null){
      studentName = student != null && student.lastName != null ? student.lastName : "bạn";
      studentName = 'Xin chào $studentName\n';

      var teacherName = teacher != null && teacher.lastName != null ? (" " + teacher.lastName) : "";
      content1 = "Bạn có cuộc hẹn với giáo viên$teacherName lúc\n";

      DateFormat formatAMPM = DateFormat('a');
      String ampm = formatAMPM.format(timerDate);
      if(ampm.toLowerCase() == 'ch'){
        ampm = "chiều";
      }else{
        ampm = 'sáng';
      }
      String formattedDate = formatDateForUI.format(timerDate);
      content2 = formattedDate.toLowerCase().replaceRange(6, 8, ampm);
    }

    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                TextSpan(
                    style: const TextStyle(
                      color: const Color(0xff00c081),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                    text: studentName),
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4B5B53),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: content1),
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4B5B53),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: content2)
              ]
          )
      ),
    );
  }

  _textTimeSheet(String text) {
    return Container(
      child: Text(
          text,
          style: const TextStyle(
              color: const Color(0xff9caaa2),
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 14.0
          )
      ),
    );
  }

  _timeDownField() {
    return Container(
      width: 375,
      height: 64,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(10)
          ),
          border: Border.all(
              color: const Color(0xffd8d8d8),
              width: 1
          ),
          color: const Color(0xffffffff)

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _timeField(hours, 'giờ'),
          SizedBox(width: 10,),
          _timeField(minutes, 'phút'),
          SizedBox(width: 10,),
          _timeField(seconds, 'giây')
        ],
      ),
    );
  }

  _timeField(int time, String timeText) {
    return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                  style: const TextStyle(
                      color: const Color(0xff00c081),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 50.0
                  ),
                  text: '$time'),
              TextSpan(
                  style: const TextStyle(
                      color: const Color(0xff4B5B53),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0
                  ),
                  text: timeText)
            ]
        )
    );
  }

  _bottomButton() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      height: 140,
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 70,
            child: Container(
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: () =>
                  {
                    setState(() {
                      leftbuttonColor = COLOR.COLOR_00C081;
                    }),

                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        leftbuttonColor = Color(0xffb6d6cb);
                      });
                    }),

                    if(currentSchedule != null){
                      Navigator.of(context).push(CalendarView.route(currentSchedule.id)),
                    }else{
                      _handleClickMe("", STRINGS.NO_SCHEDULE, 'OK', '', null)
                    }
                  },
                    child: Container(
                      width: width / 2 - 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(80),),
                          //border: Border.all(width: 5.0,color: COLOR.COLOR_00C081),
                          color: leftbuttonColor,
                          image: new DecorationImage(
                              fit: BoxFit.none, image: new AssetImage(IMAGES
                              .HOME_CANCEL), scale: 2)
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () =>
                    {
                      setState(() {
                        rightbuttonColor = COLOR.COLOR_00C081;
                      }),

                      Timer(Duration(seconds: 1), () {
                        setState(() {
                          rightbuttonColor = Color(0xffb6d6cb);
                        });
                      }),

                      if(currentSchedule != null){
                        Navigator.of(context).push(TimeSlotView.route()),
                      }else{
                        _handleClickMe("", STRINGS.NO_SCHEDULE, 'OK', '', null)
                      }
                    },
                    child: Container(
                      width: width / 2 - 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(80),),
                          //border: Border.all(width: 5.0,color: COLOR.COLOR_00C081),
                          color: rightbuttonColor,
                          image: new DecorationImage(
                              fit: BoxFit.none, image: new AssetImage(IMAGES
                              .HOME_PENCIL), scale: 2)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 100,
              height: 100,
              child: GestureDetector(
                onTap: () =>
                {
                  if(currentSchedule != null){
                    context.bloc<APIConnect>().add(CallVideo(currentSchedule.id,  "teacher")),
                    _isStartVideoCall ? VideoState(context, currentSchedule.id).initState() : "",
                  }else{
                    _handleClickMe("", STRINGS.NO_SCHEDULE, 'OK', '', null)
                  }
                },
                child: !_isStartVideoCall ? Image.asset(
                  IMAGES.HOME_CALL_GRAY, width: 100, height: 100,) : Image
                    .asset(IMAGES.HOME_CALL_GREEN, width: 100, height: 100,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openNextScreen(Route route ) {
    Navigator.of(context).push(route).then((result) => setState((){
      if(result != null){
        String formattedDate = formatDateForTimer.format(result);
        _isStartVideoCall = false;
        if(timer != null) {
          timer.cancel();
        }
        calculatorDuration(formattedDate);
        if (hours > 0 || minutes > 0 || seconds > 0) {
          startTimeout();
        }
      }
    }));
  }
}