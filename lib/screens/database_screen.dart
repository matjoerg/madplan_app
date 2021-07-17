import 'package:flutter/cupertino.dart';
import 'package:madplan_app/screens/screen_constants.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(ScreenConstants.database.title),
        ),
      ],
    );
  }
}
