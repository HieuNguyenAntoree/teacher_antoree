import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class LoginView extends StatelessWidget{
  static Route route(){
    return MaterialPageRoute<void>(builder: (_) => LoginView());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: COLOR.BG_COLOR,
      body: BlocProvider(
        create: (context){
          return APIConnect(context);
        },
        child: Center(
          child: LoginUI(),
        ),
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

  @override
  void initState() {
    super.initState();
//    emailController..text = 'admin@antoree.com';
//    passController..text = 'Antor33rotnA';
    checkAndUpdateDeviceId();
  }

  // ignore: missing_return
  VoidCallback _loginAction(){
    if (passController.text.isEmpty || emailController.text.isEmpty) {
      _handleClickMe(STRINGS.ERROR_TITLE, STRINGS.ERROR_EMPTY, STRINGS.OK, "", null);
    }else{
      context.bloc<APIConnect>().add(
          LoginSubmitted(emailController.text, passController.text));
    }
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
      String deviceId = StorageUtil.getStringValuesSF(KEY.DEVICE_ID);
      if(deviceId == ""){
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          String appName = packageInfo.appName;
          String version = packageInfo.version;
          String fcm_token = StorageUtil.getStringValuesSF(KEY.FCM_TOKEN) ;
          APIConnect(context)..add(AddDevice(os_version, deviceType, "vn", version, appName, "", fcm_token == null ? "" : fcm_token, VALUES.FORMAT_DATE_API.format(DateTime.now())));
        });
      }else{
        final accessToken = StorageUtil.getAccessToken();
        APIConnect(context)..add(UpdateDevice(deviceId, os_version, deviceType, "vn", version, appName, accessToken, fcm_token == null ? "" : fcm_token, VALUES.FORMAT_DATE_API.format(DateTime.now())));
      }
    });
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
        }
        else if (state.result is ParseJsonToObject) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushNamed(HomeViewRoute);
        }else {
          setState(() {
            _isLoading = false;
          });
          ErrorState error = state.result;
          _handleClickMe(STRINGS.ERROR_TITLE, error.msg, 'Close', 'Try again!', _loginAction);
        }
      },
      child: LoadingOverlay(
        child: SingleChildScrollView(
            child: _containerView()
        ),
        isLoading: _isLoading,
        // demo of some additional parameters
        opacity: 0.2,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  _containerView(){
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double marginLeftRight = (MediaQuery.of(context).size.width*10)/100;
     return Container(
       color: COLOR.BG_COLOR,
       alignment: Alignment.center,
       padding: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
       child: Column(
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SizedBox(height: statusBarHeight),
           _topImage(),
           SizedBox(height: 20),
           _textSection(),
           SizedBox(height: 30),
           _email(),
           SizedBox(height: 20),
           _password(),
           SizedBox(height: 30,),
//           _statusLogin(),
//           SizedBox(height: 40,),
           _loginButton(),
         ],
       ),
     );
  }

  _topImage(){
    return Container(
        padding: EdgeInsets.all(0),
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
              fontSize: 17,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  _email(){
    return Container(
      margin: EdgeInsets.all(0),
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
            fontSize: 13,
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
              color: COLOR.COLOR_9CAAA2,
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal
          ),
        ),
      ),
    );
  }

  _password(){
    return Container(
      margin: EdgeInsets.all(0),
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
            fontSize: 13,
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
            icon: new Image.asset(IMAGES.LOGIN_PASS, width: 20, height: 20,),
          ),
          hintText: STRINGS.LOGIN_PASS_HINT,
          errorText: validatePassword(),
          hintStyle: TextStyle(
              color: COLOR.COLOR_9CAAA2,
              fontSize: 13,
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
          margin: EdgeInsets.all(0),
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
      onTap: ()=> {
        _loginAction(),
      },
      child: Container(
        margin: EdgeInsets.all(0),
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