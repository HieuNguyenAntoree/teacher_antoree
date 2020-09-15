import 'package:teacher_antoree/src/1.login/login_view.dart';
import 'package:teacher_antoree/src/2.home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
//    case VideoViewRoute:
//      return _getPageRoute(
//        routeName: settings.name,
//        viewToShow: UserPage(0, true, true),
//      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
          arguments: Map(),
      ),
      builder: (_) => viewToShow);
}
