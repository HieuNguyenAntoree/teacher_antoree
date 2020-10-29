

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/1.login/login_view.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:teacher_antoree/src/7.video/video_view.dart';
import 'package:teacher_antoree/src/8.notification/notification_view.dart';
import 'package:teacher_antoree/src/customViews/dialog_manager.dart';
import 'package:teacher_antoree/src/customViews/dialog_service.dart';
import 'package:teacher_antoree/src/customViews/locator.dart';
import 'package:teacher_antoree/src/customViews/navigation_service.dart';
import 'package:teacher_antoree/src/customViews/router.dart';
import 'package:teacher_antoree/src/fcm/fcm_object.dart';
import 'package:teacher_antoree/src/fcm/receive_fcm.dart';
import 'dart:io' show Platform;
import 'const/key.dart';
import 'const/sharedPreferences.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> _handleClickMe(String title, String mess, String leftButton, String rightButton, String pageName, String scheduleId) async {
    return showDialog<void>(
      context: _navigationService.navigationKey.currentState.context,
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
                Navigator.of(context).pop();
                if(pageName == "CallView" && scheduleId != null){
                  VideoState(context, scheduleId).initState();
                }else if(scheduleId != null){
                   _navigationService.navigateTo(pageName);
                }
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if(StorageUtil.getAccessToken() != ""){
          if(Platform.isAndroid){
            Item item = itemForMessage(message);
            if(StorageUtil.getAccessToken() != ""){
              if(item.pageName != null){
                if(item.pageName == "NotificationView"){
                  _handleClickMe(item.title, item.body, "Close", '', '', item.itemId);
                }else{
                  _handleClickMe(item.title, item.body, "Close", "Open", item.pageName, item.itemId);
                }
              }
              else{
                _handleClickMe(item.title, item.body, "Close", '', '', item.itemId);
              }
            }
          }else{
            NotificationiOS item = notificationiOSForMessage(message);
            if(StorageUtil.getAccessToken() != ""){
              if(item.pageName != null){
                if(item.pageName == "NotificationView"){
                  _handleClickMe(item.title, item.body, "Close", '', '', item.itemId);
                }else{
                  _handleClickMe(item.title, item.body, "Close", "Open", item.pageName, item.itemId);
                }
              }
              else{
                _handleClickMe(item.title, item.body, "Close", '', '', item.itemId);
              }
            }
          }
        }

      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      StorageUtil.storeStringToSF(KEY.FCM_TOKEN, token);
    });
    _firebaseMessaging.subscribeToTopic("matchscore");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      home: StorageUtil.getAccessToken() == "" ? LoginView() : HomeView(),
      routes: {
        'HomeView': (context) => HomeView(),
        'LoginView': (context) => LoginView(),
        'NotificationView': (context) => NotificationView(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}
