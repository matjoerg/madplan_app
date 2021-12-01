import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
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
          sliver: BlocBuilder<GroceryListBloc, GroceryListState>(
            builder: (context, state) {
              if (state is GroceryListLoaded) {
                return SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    _buildGroceryList(state),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGroceryList(GroceryListLoaded state) {
    List<Widget> categories = [];
    state.groceryList.items.forEach((key, value) {
      categories.add(Text(key));
    });
    return categories;
  }
}
