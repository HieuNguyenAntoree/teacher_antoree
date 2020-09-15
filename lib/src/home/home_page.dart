import 'package:teacher_antoree/const/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  'Username: ${StorageUtil.getStringValuesSF(KEY.USER)}'
              ),
              RaisedButton(
                child: const Text('Logout'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]
        ),
      ),
    );
  }
}