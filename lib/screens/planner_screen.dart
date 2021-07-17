import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(ScreenConstants.planner.title),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: 1500,
          color: Colors.green,
        ),
      ),
    );
  }
}
