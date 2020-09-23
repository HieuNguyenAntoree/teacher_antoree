import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:teacher_antoree/src/5.cancel/cancel_view.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';

class NotificationView extends StatelessWidget {

  final String idSchedule;
  const NotificationView(this.idSchedule);
  static Route route(String idSchedule) {
    return MaterialPageRoute<void>(builder: (_) => NotificationView(idSchedule));
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
          child: NotificationUI(this.idSchedule),
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

class NotificationUI extends StatefulWidget {
  final String idSchedule;
  const NotificationUI(this.idSchedule);
  @override
  NotificationUIState createState() =>NotificationUIState(this.idSchedule);
}

class NotificationUIState extends State<NotificationUI>{

  bool _isStartVideoCall = false;
  String idSchedule;
  NotificationUIState(this.idSchedule);
  void initState() {
    super.initState();
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
          child: Image.asset(IMAGES.NOTIFCATION_CANCEL)
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

  _cancelButton(){
    return new GestureDetector(
      onTap: ()=> Navigator.of(context).push(CancelView.route(this.idSchedule)),
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
          color: Colors.white,
          border: Border.all(
              color: COLOR.COLOR_00C081,
              width: 4
          ),
        ),
        child: Text("Hủy hẹn",
          style: TextStyle(
              color: COLOR.COLOR_00C081,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}