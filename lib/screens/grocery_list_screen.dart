import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/models/item.dart';

import 'screens.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
    List<Widget> categoryItemsList = [];
    state.groceryList.items.forEach((key, value) {
      categoryItemsList.add(_buildCategoryItemsList(key, value));
    });
    return categoryItemsList;
  }

  Widget _buildCategoryItemsList(String categoryName, List<Item> items) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Text(categoryName),
          ..._buildItemsList(items),
        ],
      ),
    );
  }

  List<Widget> _buildItemsList(List<Item> items) {
    List<Widget> itemTiles = [];
    items.forEach((item) {
      itemTiles.add(_buildItemTile(item));
    });
    return itemTiles;
  }

  Widget _buildItemTile(Item item) {
    return ListTile(
      title: Text(item.name),
      leading: item.checked ? Icon(CupertinoIcons.check_mark_circled_solid) : Icon(CupertinoIcons.circle),
      onTap: () {
        setState(() {
          item.checked = !item.checked;
        });
      },
    );
  }
}
