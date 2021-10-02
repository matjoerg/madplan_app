import 'package:flutter/cupertino.dart';
import 'package:madplan_app/constants/pixels.dart';

import 'screens.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(ScreenConstants.list.title),
        ),
        SliverPadding(
          padding: EdgeInsets.all(Pixels.defaultMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              _buildListCategories(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildListCategories() {
    List<Widget> categories = [];
    return categories;
  }
}
