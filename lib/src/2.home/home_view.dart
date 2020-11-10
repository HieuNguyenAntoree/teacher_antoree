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
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teacher_antoree/src/8.notification/notification_view.dart';

class HomeView extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeView());
  }

  HomeUIState createState() => HomeUIState();
}

class HomeUIState extends State<HomeView> {

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
  static final DateFormat formatDateForUI = DateFormat("hh:mm a 'on' EEEE  dd | MM | yyyy");
  final interval = const Duration(seconds: 1);

  startTimeout([int milliseconds]) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        if(StorageUtil.getAccessToken() == ''){
          timer.cancel();
        }
        print(timer.tick);

        seconds = seconds - 1;
        if (hours == 0 && minutes == VALUES.DELAY_CALL_TIME && seconds == 0) {
          _isStartVideoCall = true;
          Timer(Duration(minutes: 2*VALUES.DELAY_CALL_TIME),(){
            timer.cancel();
            setState(() {
              _isStartVideoCall = false;//Nút gọi này được hiện ra và enable bắt đầu trước và sau 5 phút so với giờ của giờ hẹn
            });
          });
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
            if (hours <= 0) {
              minutes = 0;
              seconds = 60;
            } else {
              hours = hours - 1;
              seconds = 60;
              minutes = 60;
            }

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
  APIConnect apiconnect;
  @override
  void initState() {
    super.initState();
//    Intl.defaultLocale = 'vi_VN';
//    initializeDateFormatting();
    apiconnect = APIConnect(context);
    loadDataFromLocal();
    checkAndUpdateDeviceId();
  }

  Future checkAndUpdateDeviceId() async {
    var os_version = "";
    var deviceType = "ANDROID";
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      os_version = androidInfo.version.release;

    }
    else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      os_version = iosInfo.systemName;
      deviceType = "IOS";
    }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = "antoree_teacher";//packageInfo.appName;
      String version = packageInfo.version;
      String fcm_token = StorageUtil.getStringValuesSF(KEY.FCM_TOKEN) ;
      final accessToken = StorageUtil.getAccessToken();
      if(StorageUtil.getStringValuesSF(KEY.DEVICE_ID) == ""){
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          String appName = packageInfo.appName;
          String version = packageInfo.version;
          String fcm_token = StorageUtil.getStringValuesSF(KEY.FCM_TOKEN) ;
          APIConnect(context)..add(AddDevice(os_version, deviceType, "vn", version, appName,  fcm_token == null ? "" : fcm_token, DateTime.now()));
        });
      }else{
        APIConnect(context)..add(UpdateDevice(StorageUtil.getStringValuesSF(KEY.DEVICE_ID), os_version, deviceType, "vn", version, appName, fcm_token == null ? "" : fcm_token, DateTime.now()));
      }
    });
  }

  @override
  void dispose() {
    if(timer != null){
      timer.cancel();
    }
    super.dispose();
  }

  loadDataFromLocal(){
    _isStartVideoCall = false;
    scheduleList = StorageUtil.getScheduleList();
    if(scheduleList != null){
      if(scheduleList.objects.length > 0) {
        for(var i = 0; i < scheduleList.objects.length; i ++){
          DateTime nowTime = DateTime.parse(VALUES.FORMAT_DATE_API.format(DateTime.now()));
          int days = scheduleList.objects[i].date.difference(nowTime).inDays;
          if(days < 0){
            continue;
          }
          List<Schedule> list = scheduleList.objects[i].schedules;
          if(list.length > 0){
            Schedule schMin;
            for(var i = 0; i < list.length; i++){
              if(currentSchedule != null){
                i = list.length - 1;
                break;
              }
              Schedule sch = list[i];
              if(sch.startTime.difference(nowTime).inDays > 0){
                schMin = schMin;
                break;
              }else{
                if(sch.startTime.hour == nowTime.hour && sch.startTime.minute >  nowTime.minute){
                  schMin = sch;
                  break;
                }else if(sch.startTime.hour > nowTime.hour){
                  schMin = sch;
                  break;
                }
              }
            }
            if(schMin != null) {
              if(schMin.status == 1){
                int ms = schMin.startTime.difference(nowTime).inMinutes;
                if( ms > -VALUES.DELAY_CALL_TIME){
                  currentSchedule = schMin;
                  timerDate = currentSchedule.startTime;
                  if(timer != null){
                    timer.cancel();
                  }
                  calculatorDuration(formatDateForTimer.format(timerDate));
                  if (hours > 0 || minutes > 0 || seconds > 0) {
                    startTimeout();
                  }else if (hours == 0 || minutes <= 0) {
                    _isStartVideoCall = true;
                    Timer(Duration(minutes: VALUES.DELAY_CALL_TIME),(){
                      setState(() {
                        currentSchedule = null;
                        _isStartVideoCall = false;//Nút gọi này được hiện ra và enable bắt đầu trước và sau 5 phút so với giờ của giờ hẹn
                      });
                    });
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
              }
            }
          }
        }
      }
    }
  }

  VoidCallback getScheduleListFromAPI(){
    apiconnect.add(ScheduleFetched(0,DateTime.now(), DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS))));
  }

  VoidCallback logout(){
    APIConnect(context)..add(DeleteDevice(StorageUtil.getStringValuesSF(KEY.DEVICE_ID)));
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
    // TODO: implement build
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
//              icon: Image.asset(IMAGES.HOME_NOTI_OFF, width: 44, height: 40,),
//              onPressed: () {
//                _openNextScreen(NotificationView.route());
//              },
//            ),
//          ],
          leading: IconButton(
            icon: Image.asset(IMAGES.HOME_LOGOUT, width: 29, height: 25,),
            onPressed: () {
              if(timer != null){
                timer.cancel();
              }
              logout();
              StorageUtil.removeAllCache();
              if(Navigator.of(context).canPop()){
                Navigator.of(context).pop();
              }
              else{
                Navigator.of(context).popAndPushNamed('LoginView');
              }
            },
          ),
        ),
        body: BlocProvider(
            create: (context) => apiconnect..add(ScheduleFetched(0,DateTime.now(), DateTime.now().add(new Duration(days: VALUES.SCHEDULE_DAYS)))),
            child: BlocListener<APIConnect, ApiState>(
                listener: (context, state){
                  if (state.result is StateInit) {
                    setState(() {
                      _isLoading = true;
                    });
                  }else if (state.result is LoadingState) {
                    setState(() {
                      _isLoading = true;
                    });
                  }else if (state.result is SuccessState) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  else if (state.result is ParseJsonToObject) {
                    setState(() {
                      _isLoading = false;
                    });
                    scheduleList = StorageUtil.getScheduleList();
                    if(scheduleList != null) {
                      if (scheduleList.objects.length == 0) {
                        _handleClickMe(STRINGS.ERROR_TITLE, STRINGS.NO_SCHEDULE, "Close", "", null);
                      }
                    }
                    setState(() {
                      loadDataFromLocal();
                    });

                    if(scheduleList != null) {
                      if (scheduleList.objects.length > 0) {
                        if(currentSchedule == null){
                          _handleClickMe(STRINGS.ERROR_TITLE, STRINGS.NO_SCHEDULE, 'OK', '', null);
                        }
                      }

                    }

                  }else {
                    setState(() {
                      _isLoading = false;
                    });
                    ErrorState error = state.result;
                    _handleClickMe(STRINGS.ERROR_TITLE, error.msg, "Close", "Try again!", getScheduleListFromAPI);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 1.0,
                        color: COLOR.COLOR_D8D8D8,
                      ),
                      currentSchedule  == null ? Expanded(
                          child:  Center(
                              child: _containerTop()
                          )) : _containerTop(),
                      currentSchedule  != null ? Expanded(
                          child:  currentSchedule != null ? Center(
                              child: _containerView()
                          ) : Container(

                          )
                      ) : SizedBox(height: 0,),
                      _bottomButton(),
                    ],
                  ),
                )
            )
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

  _containerTop(){
    return Container(
      height: 250,
      child: Column(
        children: [
          SizedBox(height: 50,),
          _avatarImage(),
          SizedBox(height: 12),
          _helloUserText(),
        ],
      ),
    );
  }

  _containerView(){
    double marginLeftRight = (MediaQuery.of(context).size.width*4.8)/100;
    return Container(
      height: 130,
      color: COLOR.BG_COLOR,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
      child: Column(
        children: [
          _textTimeSheet('we have'),
          SizedBox(height: 5),
          _timeDownField(),
          SizedBox(height: 5,),
          _textTimeSheet('testing is comming'),
        ],
      ),
    );
  }

  _avatarImage() {
    return Center(
        child: Container(
          height: 125,
          width: 137,
          child: (teacher != null && teacher.avatar != null && teacher.avatar.url != "") ? CachedNetworkImage(
            imageUrl: teacher.avatar.url,
            imageBuilder:
                (context, imageProvider) =>
                Container(
                  decoration: _borderAvatar(imageProvider, 2),
                ),
            placeholder: (context, url) =>
                Container(
                  decoration: _borderAvatar(new AssetImage(IMAGES
                      .HOME_AVATAR), 2),
                ),
            errorWidget: (context, url, error)
            => Container(
                decoration: _borderAvatar(new AssetImage(IMAGES
                    .HOME_AVATAR), 2)
            ),

          ) :
          Container(
              decoration: _borderAvatar(new AssetImage(IMAGES
                  .HOME_AVATAR), 2)
          ),
        )
    );
  }

  _borderAvatar(ImageProvider image, double scale) {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(80),
        bottomRight: Radius.circular(80),
      ),
      border: Border.all(width: 5.0, color: COLOR.COLOR_00C081),
      color: Colors.white,
      image: new DecorationImage(
        fit: BoxFit.none,
        image: image,
        scale: scale,
      ),
    );
  }

  _helloUserText() {
    String studentName = 'Hi you\n';
    String content1 = "You don't have course now\n";
    String content2 = "";
    if(currentSchedule != null){
      studentName = teacher != null && teacher.lastName != null ? teacher.lastName : "you";
      studentName = 'Hi $studentName\n';

      var teacherName = student != null && student.lastName != null ? (" " + student.lastName) : "";
      content1 = "You will have a test with$teacherName at\n";

      String formattedDate = formatDateForUI.format(timerDate);
      content2 = formattedDate;
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
    double width = (MediaQuery.of(context).size.width - 2*((MediaQuery.of(context).size.width*4.8)/100))/3 - 2;
    return Container(
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
          _timeField(hours, 'hr', width),
          _timeField(minutes, 'min', width),
          _timeField(seconds, 'nd', width),
        ],
      ),
    );
  }

  _timeField(int time, String timeText, double width) {
    return Container(
        width: width,
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 5),
                      child: Text(
                        time > 9 ? '$time' : '  $time',
                        style: const TextStyle(
                            color: const Color(0xff00c081),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 46.0
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(right: 5) ,
                  child: Text(
                    '$timeText',
                    style: const TextStyle(
                        color: const Color(0xff4B5B53),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  _bottomButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  Container(
                    width: width / 2 - 10,
                    child: RaisedButton(
                        color: currentSchedule == null  ? COLOR.COLOR_D8D8D8 : leftbuttonColor,
                        highlightColor: currentSchedule != null  ? COLOR.COLOR_00C081 : COLOR.COLOR_D8D8D8,
                        splashColor: currentSchedule != null  ? COLOR.COLOR_00C081 : Colors.transparent,
                        onPressed: () {
                          if(currentSchedule != null){
                            _openNextScreen(CalendarView.route(currentSchedule.id));
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(80),)),
                        child: Image.asset(IMAGES.HOME_CANCEL, width: 40, height: 70,)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: width / 2 - 10,
                    child: RaisedButton(
                        color: leftbuttonColor,
                        highlightColor: COLOR.COLOR_00C081,
                        splashColor: COLOR.COLOR_00C081,
                        onPressed: () {
                          _openNextScreen(TimeSlotView.route());
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(80),)),
                        child: Image.asset(IMAGES.HOME_PENCIL, width: 40, height: 70,)
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      color: _isStartVideoCall ? COLOR.COLOR_00C081 : (
                          !_isStartVideoCall && currentSchedule == null ? COLOR.COLOR_D8D8D8 : COLOR.COLOR_B6D6CB
                      ),
                      elevation: 0.0,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Image.asset(IMAGES.HOME_CALL_ICON, width: 40, height: 40,),
                      onPressed: () {
                        if(currentSchedule != null && teacher != null){
                          context.bloc<APIConnect>().add(CallVideo(currentSchedule.id,  "teacher"));
                        _isStartVideoCall ? VideoState(context, currentSchedule.id).initState() : "";
                        }
                      },
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  void _openNextScreen(Route route ) {
    Navigator.of(context).push(route).then((result) => setState((){
      getScheduleListFromAPI();
    }));
  }
}