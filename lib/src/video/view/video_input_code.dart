import 'package:flutter/material.dart';

class FocusVisibilityDemo extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute<void>(builder: (_) => FocusVisibilityDemo());
  }

  @override
  _FocusVisibilityDemoState createState() => new _FocusVisibilityDemoState();
}


class _FocusVisibilityDemoState extends State<FocusVisibilityDemo> {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _showDialog(context),
      );
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Course Code', hintText: 'XYZ12345'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),),
    );
  }
}


class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: EdgeInsets.only(top: 50),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}