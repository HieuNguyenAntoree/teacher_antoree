import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName) {
    if(_navigationKey.currentState.canPop()){
      if(routeName != "NotificationView" ) {
        return _navigationKey.currentState
            .popAndPushNamed(routeName);
      }else{
        return _navigationKey.currentState
            .pushNamed(routeName);
      }
    }
    else{
      return _navigationKey.currentState
          .pushNamed(routeName);
    }
  }
}
