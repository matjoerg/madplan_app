import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/blocs/database/database_bloc.dart';
import 'package:madplan_app/data/models/models.dart';

part 'grocery_list_event.dart';
part 'grocery_list_state.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  final DatabaseBloc databaseBloc;
  late StreamSubscription databaseSubscription;
  List<Category>? _categories;

  GroceryListBloc({required this.databaseBloc}) : super(GroceryListLoaded(groceryList: GroceryList.empty())) {
    databaseSubscription = databaseBloc.stream.listen((state) {
      if (state is DatabaseLoaded) {
        _categories = state.categories;
      }
    });

    on<GroceryListCreated>((event, emit) {
      List<Item> allItems = event.mealPlan.getAllItems();
      Map<String, List<Item>> _itemsByCategory = {};
      List<Category>? categories = _categories;

      if (categories == null) {
        _itemsByCategory.addAll({"": allItems});
      } else {
        categories.sort((a, b) {
          int? aSortOrder = a.sortOrder;
          int? bSortOrder = b.sortOrder;
          if (aSortOrder == null) {
            return 1;
          }
          if (bSortOrder == null) {
            return -1;
          }
          if (aSortOrder < bSortOrder) {
            return -1;
          }
          return 0;
        });
        for (Category category in categories) {
          List<Item> allItemsInCategory = allItems.where((item) => item.categoryLabel == category.label).toList();
          if (allItemsInCategory.isNotEmpty) {
            _itemsByCategory.addAll({category.label: allItemsInCategory});
          }
        }
      }

      emit(GroceryListLoaded(
        groceryList: GroceryList(
          itemsByCategory: _itemsByCategory,
        ),
      ));
    });
  }

  @override
  Future<void> close() {
    databaseSubscription.cancel();
    return super.close();
  }
}
