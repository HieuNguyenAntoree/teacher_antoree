import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/const/sharedPreferences.dart';
import 'package:teacher_antoree/models/schedule.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:teacher_antoree/src/5.cancel/cancel_view.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';

class NotificationView extends StatelessWidget {

  const NotificationView();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NotificationView());
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
          leading: IconButton(
            icon: Image.asset(IMAGES.BACK_ICON, width: 26, height: 20,),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        body: NotificationUI(),
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

class NotificationUI extends StatefulWidget {
  const NotificationUI();
  @override
  NotificationUIState createState() =>NotificationUIState();
}

class NotificationUIState extends State<NotificationUI>{

  String idSchedule;
  String avatarURL;
  String teacherName;
  void initState() {
    super.initState();
    loadDataFromLocal();
  }


  loadDataFromLocal(){
    ScheduleModel scheduleList = StorageUtil.getScheduleList();
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
              Schedule currentSchedule = schMin;
              for(var j = 0; j < currentSchedule.users.length; j ++){
                User _user = currentSchedule.users[j];
                if(_user.role == "teacher"){
                  User teacher = _user;
                  teacherName = teacher.lastName;
                }
              }
            }
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 1.0,
            color: COLOR.COLOR_D8D8D8,
          ),
          const Padding(padding: EdgeInsets.all(40)),
          _topImage(),
          SizedBox(height: 20),
          _textSection(),
          SizedBox(height: 30),
          _okButton(),
          SizedBox(height: 20),
          _cancelButton(),
        ],
      ),
    );
  }

  _topImage() {
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: Image.asset(IMAGES.NOTIFCATION_CANCEL, width: 93, height: 80,)
      ),
    );
  }

  _textSection() {
    return Center(
      child: Text(
        "Cuộc hẹn của bạn đã bị hủy\nvì giáo viên có việc đột xuất\n\nAntoree rất tiếc và trải nghiệm này",
        style: const TextStyle(
            color:  const Color(0xff4B5B53),
            fontWeight: FontWeight.w400,
            fontFamily: "Montserrat",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _okButton(){
    return new GestureDetector(
      onTap: ()=> Navigator.popUntil(context, ModalRoute.withName(HomeViewRoute)),
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
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
        child: Text("Đổi lịch hẹn / giáo viên",
          style: TextStyle(
              color: const Color(0xffffffff),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }

  bool isPressedCancelButton = false;
  _cancelButton() {
    return _cancButtonPressed();
  }

  _cancButtonPressed(){
    return Listener(
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(5),
          ),
          color: isPressedCancelButton ? COLOR.COLOR_00C081 : Colors.white ,
          border: Border.all(
              color: COLOR.COLOR_00C081,
              width: 4
          ),
        ),
        child: Text("Hủy hẹn",
          style: TextStyle(
              color: isPressedCancelButton ? Colors.white : COLOR.COLOR_00C081,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),),
      ),
      onPointerDown: (_) {
        setState(() {
          isPressedCancelButton = true;
        });

      },
      onPointerUp: (_) {
        setState(() {
          isPressedCancelButton = false;
        });
      },
    );
  }

  void _openNextScreen(Route route ) {
    Navigator.of(context).push(route).then((result) => setState((){
      if(result != null){
        Navigator.of(context).pop(result);
      }
    }));
  }
}