import 'dart:async';

import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/3.changeschedule/schedule_view.dart';
import 'package:teacher_antoree/src/4.calendar/calendar_view.dart';
import 'package:teacher_antoree/src/7.video/video_view.dart';
import 'package:teacher_antoree/src/8.notification/notification_view.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:teacher_antoree/src/customViews/route_names.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.name;
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
          child: HomeUI(),
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
                StorageUtil.removeValues(KEY.PROFILE);
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

class HomeUI extends StatefulWidget {
  @override
  HomeUIState createState() => HomeUIState();
}

class HomeUIState extends State<HomeUI> {

  bool _isStartVideoCall = false;
  APIConnect _apiConnect = APIConnect();

  Color leftbuttonColor = Color(0xffb6d6cb);
  Color rightbuttonColor = Color(0xffb6d6cb);

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int days = 0;
  Timer timer;

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  final String formatted = formatter.format(now);
  String exampleDate = now.year.toString() + '-'
      + (now.month > 9 ? now.month.toString() : '0' + now.month.toString()) +
      '-'
      + (now.day > 9 ? now.day.toString() : '0' + now.day.toString()) + ' '
      + (now.hour > 9 ? now.hour.toString() : '0' + now.hour.toString()) + ':'
      + ((now.minute + 2 > 9) ? (now.minute + 2).toString() : '0' +
          (now.minute + 2).toString()) + ':'
      + (now.second > 9 ? now.second.toString() : '0' + now.second.toString());
  final interval = const Duration(seconds: 1);

  startTimeout([int milliseconds]) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        if(seconds - 1 < 0){
          _isStartVideoCall = true;
          timer.cancel();
        }
        seconds = seconds - 1;
        if (hours == 0 && minutes == 0 && seconds == 0) {
          _isStartVideoCall = true;
          timer.cancel();
        } else if (seconds == 0) {
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
          } else {
            seconds = 0;
            hours = 0;
            minutes = 0;
            _isStartVideoCall = true;
            timer.cancel();
          }
        }
      });
    });
  }

  void calculatorDuration(String date) {
    setState(() {
      DateTime dob = DateTime.parse(date);
      Duration dur = dob.difference(DateTime.now());
      int s = dur.inSeconds;
      if (s > 0) {
//        days = dur.inDays;
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
    });
  }

  @override
  void initState() {
    super.initState();
    _apiConnect.init();
    listenConnectionResponse();
    print(now.minute);
    calculatorDuration(exampleDate);
    if (hours > 0 || minutes > 0 || seconds > 0) {
      startTimeout();
    }
  }

  void listenConnectionResponse() {
    _apiConnect.hasConnectionResponse().listen((Result result) {
      if (result is LoadingState) {
        showAlertDialog(context: context,
            title: STRINGS.ERROR_TITLE,
            message: result.msg,
            actions: [AlertDialogAction(isDefaultAction: true, label: 'OK')],
            actionsOverflowDirection: VerticalDirection.up);
      } else if (result is SuccessState) {
        //Navigator.push(context, ProfilePage.route());
      } else {
        ErrorState error = result;
        showAlertDialog(context: context,
            title: STRINGS.ERROR_TITLE,
            message: error.msg,
            actions: [AlertDialogAction(isDefaultAction: true, label: 'OK')],
            actionsOverflowDirection: VerticalDirection.up);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
              image: new DecorationImage(
                  fit: BoxFit.none, image: new AssetImage(IMAGES
                  .HOME_AVATAR), scale: 2)
          ),
        )
    );
  }

  _helloUserText() {
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
                    text: "Xin chào Trang\n"),
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4B5B53),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: "Bạn có cuộc hẹn với thầy Peter lúc\n"),
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4B5B53),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: " 8:00 chiều thứ hai 18 | 07 | 2020")
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
                    Navigator.of(context).push(CalendarView.route()),
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        leftbuttonColor = Color(0xffb6d6cb);
                      });
                    }),
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
                     Navigator.of(context).push(MyHomePage.route()),
                      Timer(Duration(seconds: 1), () {
                        setState(() {
                          rightbuttonColor = Color(0xffb6d6cb);
                        });
                      }),
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
                onTap: () => _isStartVideoCall ? VideoState().initState() : "",
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
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(result);

      setState(() {
        _isStartVideoCall = false;
        timer.cancel();
        exampleDate = formattedDate;
        calculatorDuration(exampleDate);
        if (hours > 0 || minutes > 0 || seconds > 0) {
          startTimeout();
        }
      });

    }));
  }
}