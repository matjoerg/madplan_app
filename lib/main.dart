import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/screens/base_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: BaseScreen(),
    );
  }
}
