import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: HomeScreen(),
    );
  }
}
