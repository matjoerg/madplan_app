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
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.all(Pixels.defaultMargin),
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
        ),
      ],
    );
  }

  List<Widget> _buildGroceryList(GroceryListLoaded state) {
    List<Widget> categoryItemsList = [];
    state.groceryList.itemsByCategory.forEach((key, value) {
      categoryItemsList.add(_buildCategoryItemsList(key, value));
    });
    return categoryItemsList;
  }

  Widget _buildCategoryItemsList(String categoryName, List<Item> items) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ..._buildItemsList(items),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  List<Widget> _buildItemsList(List<Item> items) {
    List<Widget> itemTiles = [];
    for (var item in items) {
      itemTiles.add(_buildItemTile(item));
    }
    return itemTiles;
  }

  Widget _buildItemTile(Item item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          item.checked = !item.checked;
        });
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: item.name,
            style: TextStyle(
              fontSize: 16,
              color: item.checked ? Colors.grey : Colors.black,
              decoration: item.checked ? TextDecoration.lineThrough : null,
            ),
            children: [
              TextSpan(
                text: '  (' + item.count.ceil().toString() + ')',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
