import 'dart:async';
import 'package:teacher_antoree/src/customViews/navigation_service.dart';
import 'package:teacher_antoree/src/customViews/locator.dart';

final Map<String, Item> _items = <String, Item>{};
Item itemForMessage(Map<String, dynamic> message) {
  final dynamic notification = message['notification'] ?? message;
  final String title = notification['title'];
  final String body = notification['body'];
  final dynamic data = message['data'] ?? message;
  final String itemId = data['idSchedule'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId, title: title, body: body))
    .._pageName = data['screen'];
  return item;
}

class Item {
  Item({this.itemId, this.title, this.body});

  final String itemId;
  final String title;
  final String body;

  StreamController<Item> _controller = StreamController<Item>.broadcast();

  Stream<Item> get onChanged => _controller.stream;
  final NavigationService _navigationService = locator<NavigationService>();

  String _pageName;

  String get pageName => _pageName;

  set pageName(String value) {
    _pageName = value;
    _controller.add(this);
  }
}

final Map<String, NotificationiOS> _notification_iOS = <String, NotificationiOS>{};
NotificationiOS notificationiOSForMessage(Map<String, dynamic> message) {
  final dynamic aps = message['aps'] ?? message;
  final dynamic alert = aps['alert'] ?? message;
  final String title = alert['title'];
  final String body = alert['body'];
  final int badge = aps['badge'];
  final String idSchedule = message['idSchedule'];
  final NotificationiOS item = _notification_iOS.putIfAbsent(idSchedule, () => NotificationiOS(itemId: idSchedule, title: title, body: body))
    .._pageName = message['screen'];
  return item;
}

class NotificationiOS {
  NotificationiOS({this.itemId, this.title, this.body,});

  final String itemId;
  final String title;
  final String body;

  StreamController<NotificationiOS> _controller = StreamController<NotificationiOS>.broadcast();

  Stream<NotificationiOS> get onChanged => _controller.stream;
  final NavigationService _navigationService = locator<NavigationService>();

  String _pageName;

  String get pageName => _pageName;

  set pageName(String value) {
    _pageName = value;
    _controller.add(this);
  }
}

