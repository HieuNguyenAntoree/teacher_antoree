

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/src/1.login/login_view.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:teacher_antoree/src/customViews/dialog_manager.dart';
import 'package:teacher_antoree/src/customViews/dialog_service.dart';
import 'package:teacher_antoree/src/customViews/locator.dart';
import 'package:teacher_antoree/src/customViews/navigation_service.dart';
import 'package:teacher_antoree/src/customViews/router.dart';
import 'package:teacher_antoree/src/fcm/fcm_object.dart';
import 'package:teacher_antoree/src/fcm/receive_fcm.dart';

import 'const/sharedPreferences.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Item item = itemForMessage(message);
        var dialogResponse = await _dialogService.showConfirmationDialog(
            title: item.title,
            description: item.body,
            confirmationTitle: "Open",
            cancelTitle: "Close");

        if (dialogResponse.confirmed) {
          _navigationService.navigateTo(item.pageName);
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
      },
      onGenerateRoute: generateRoute,
    );
  }
}
