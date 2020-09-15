import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginView extends StatelessWidget{
  static Route route(){
    return MaterialPageRoute<void>(builder: (_) => LoginView());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: LoginUI(),
      ),
    );
  }
}

class LoginUI extends StatefulWidget {
  @override
  LoginUIState createState() => LoginUIState();
}

class LoginUIState extends State<LoginUI>{

  bool _isLoading = false;
  bool _isStatusLogin = true;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  APIConnect _apiConnect = APIConnect();

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
        setState(() {
          _isLoading = false;
        });
      } else if (result is SuccessState) {
        setState(() {
          _isLoading = false;
        });
        //Navigator.push(context, ProfilePage.route());
      } else {
        setState(() {
          _isLoading = false;
        });
        ErrorState error = result;
        showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingOverlay(
      child: SingleChildScrollView(
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
              _email(),
              SizedBox(height: 20),
              _password(),
              SizedBox(height: 30,),
              _statusLogin(),
              SizedBox(height: 40,),
              _loginButton(),
            ],
          ),
        ),
      ),
      isLoading: _isLoading,
      // demo of some additional parameters
      opacity: 0.2,
      progressIndicator: CircularProgressIndicator(),
    );
  }

  _topImage(){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        child: Image.asset(IMAGES.LOGIN_TOPIMAGE)
    );
  }

  _textSection(){
    return Container(
        alignment: Alignment.center,
        child: Text(STRINGS.LOGIN_TEXT,
          style: TextStyle(
              color: COLOR.COLOR_00C081,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  _email(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      height: 64,
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
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
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
          prefixIcon: new IconButton(
            icon: new Image.asset(IMAGES.LOGIN_ACCOUNT, width: 24, height: 27,),
          ),
          hintText: STRINGS.LOGIN_EMAIL_HINT,
          errorText: validateEmail(),
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

  _password(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      height: 64,
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
        obscureText: true,
        controller: passController,
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
          prefixIcon: new IconButton(
            icon: new Image.asset(IMAGES.LOGIN_PASS, width: 24, height: 27,),
          ),
          hintText: STRINGS.LOGIN_PASS_HINT,
          errorText: validatePassword(),
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

  _statusLogin(){
    return new GestureDetector(
      onTap: ()=> setState(() {
        _isStatusLogin = !_isStatusLogin;
        StorageUtil.storeBoolToSF(KEY.LOGIN_STATUS, _isStatusLogin);
      }),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.centerLeft,
        height: 25,
        child: Row(
          children: [
            _isStatusLogin ? Image.asset(IMAGES.LOGIN_CHECKBOX, width: 24, height: 24,) : Image.asset(IMAGES.LOGIN_UNCHECKBOX, width: 24, height: 24,),
            SizedBox(width: 10),
            Text(STRINGS.LOGIN_LOGIN_STATUS,
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

   _loginButton(){
    return new GestureDetector(
      onTap: ()=> Navigator.of(context).pushNamed(HomeViewRoute),
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
          child: Text(STRINGS.LOGIN_BUTTON,
            style: TextStyle(
                color: const Color(0xffffffff),
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold
            ),),
      ),
    );
  }

  String validatePassword() {
    if (!(passController.text.length > 5) && passController.text.isNotEmpty) {
      return STRINGS.LOGIN_PASS_VALID;
    }
    return null;
  }

  String validateEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(emailController.text) && emailController.text.isNotEmpty)
      return STRINGS.LOGIN_EMAIL_VALID;
    else
      return null;
  }

}