import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';

class CancelView extends StatelessWidget {
  final String idSchedule;
  const CancelView(this.idSchedule);
  static Route route(String idSchedule) {
    return MaterialPageRoute<void>(builder: (_) => CancelView(idSchedule));
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
              create: (context){
                return APIConnect(context);
              },
              child: CancelUI(this.idSchedule),
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

class CancelUI extends StatefulWidget {
  final String idSchedule;
  const CancelUI(this.idSchedule);
  @override
  CancelUIState createState() =>CancelUIState(this.idSchedule);
}

class CancelUIState extends State<CancelUI>{

  bool _isCheckBox1 = true;
  bool _isCheckBox2 = false;
  bool _isLoading = false;
  TextEditingController reasonController = new TextEditingController();

  String idSchedule;
  CancelUIState(this.idSchedule);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          Navigator.popUntil(context, ModalRoute.withName(HomeViewRoute));
        }else {
          setState(() {
            _isLoading = false;
          });
          ErrorState error = state.result;
          showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
        }
      },
      child: LoadingOverlay(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(padding: EdgeInsets.all(40)),
              _topImage(),
              SizedBox(height: 20),
              _textSection(),
              SizedBox(height: 30),
              _checkbox1(),
              SizedBox(height: 20),
              _checkbox2(),
              SizedBox(height: 20),
              _reasonTextView(),
              SizedBox(height: 30),
              _cancelButton(),
            ],
          ),
        ),
        isLoading: _isLoading,
        // demo of some additional parameters
        opacity: 0.2,
        progressIndicator: CircularProgressIndicator(),
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
            "Antoree rất muốn biết\nvì sao bạn muốn hủy buổi test",
            style: const TextStyle(
                color:  const Color(0xff4B5B53),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle:  FontStyle.normal,
                fontSize: 14.0
            )
        )
    );
  }

  _checkbox1(){
    return new GestureDetector(
      onTap: ()=> setState(() {
        _isCheckBox1 = !_isCheckBox1;
        _isCheckBox2 = !_isCheckBox2;
      }),
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          height: 25,
          child: Row(
            children: [
              _isCheckBox1 ? Image.asset(IMAGES.LOGIN_CHECKBOX, width: 24, height: 24,) : Image.asset(IMAGES.LOGIN_UNCHECKBOX, width: 24, height: 24,),
              SizedBox(width: 10),
              Text("Thay đổi kế hoạch học tập",
                style: TextStyle(
                    color: const Color(0xff4B5B53),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal
                ),),
            ],
          )
      ),
    );
  }

  _checkbox2(){
    return new GestureDetector(
      onTap: ()=> setState(() {
        _isCheckBox2 = !_isCheckBox2;
        _isCheckBox1 = !_isCheckBox1;
      }),
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          height: 25,
          child: Row(
            children: [
              _isCheckBox2 ? Image.asset(IMAGES.LOGIN_CHECKBOX, width: 24, height: 24,) : Image.asset(IMAGES.LOGIN_UNCHECKBOX, width: 24, height: 24,),
              SizedBox(width: 10),
              Text("Thay đổi kế hoạch học tập",
                style: TextStyle(
                    color: const Color(0xff4B5B53),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal
                ),),
            ],
          )
      ),
    );
  }

  _reasonTextView(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(10)
          ),
          border: Border.all(
              color: COLOR.COLOR_D8D8D8,
              width: 1
          ),
          color: const Color(0xffffffff)
      ),
      child: TextFormField(
        cursorColor: COLOR.COLOR_00C081,
        keyboardType: TextInputType.text,
        controller: reasonController,
        style: TextStyle(
            color: COLOR.COLOR_00C081,
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold
        ),
        decoration: new InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(right: 10, top: 15, left: 10, bottom: 15),
          hintText: "Lý do khác",
          hintStyle: TextStyle(
              color: COLOR.COLOR_D8D8D8,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal
          ),
        ),
      ),
    );
  }

  _cancelButton(){
    return new GestureDetector(
      onTap: ()=> {
        context.bloc<APIConnect>().add(CancelSchedule( this.idSchedule, _isCheckBox1 ? 'change_plan' : 'other', reasonController.text)),
      },
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
        child: Text("Hủy hẹn",
          style: TextStyle(
              color: const Color(0xffffffff),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}