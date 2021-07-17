import 'package:flutter/cupertino.dart';
import 'package:madplan_app/screens/screen_constants.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(ScreenConstants.list.title),
        ),
      ],
    );
  }
}
