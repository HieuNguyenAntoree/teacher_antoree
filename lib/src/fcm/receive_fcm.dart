import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/src/fcm/fcm_object.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }

}

//Widget buildDialog(BuildContext context, Item item) {
//  return AlertDialog(
//    content: Text("${item.matchteam} with score: ${item.score}"),
//    actions: <Widget>[
//      FlatButton(
//        child: const Text('CLOSE'),
//        onPressed: () {
//          Navigator.pop(context, false);
//        },
//      ),
//      FlatButton(
//        child: const Text('SHOW'),
//        onPressed: () {
//          Navigator.pop(context, true);
//        },
//      ),
//    ],
//  );
//}

//void showItemDialog(Map<String, dynamic> message, BuildContext context) {
////  final navigatorKey = GlobalKey<NavigatorState>();
////  final context = navigatorKey.currentState.overlay.context;
//  showDialog<bool>(
//    context: context,
//    builder: (_) => buildDialog(context, itemForMessage(message)),
//  ).then((bool shouldNavigate) {
//    if (shouldNavigate == true) {
//      navigateToItemDetail(message);
//    }
//  });
//}
//
//void navigateToItemDetail(Map<String, dynamic> message) {
//  final navigatorKey = GlobalKey<NavigatorState>();
//  final context = navigatorKey.currentState.overlay.context;
//  final Item item = itemForMessage(message);
//  // Clear away dialogs
//  Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//  if (!item.route.isCurrent) {
//    Navigator.push(context, item.route);
//  }
//}