import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:madplan_app/data/models/models.dart';

part 'grocery_list_event.dart';
part 'grocery_list_state.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  GroceryListBloc() : super(GroceryListState(groceryList: GroceryList())) {
    on<GroceryListCreated>((event, emit) {
      try {
        emit(state.copyWith(groceryList: GroceryList(initialItems: event.mealPlan.getAllItems())));
      } catch (e, s) {
        debugPrint("GroceryListBloc error");
        //TODO: Implement error state
      }
    });

    on<GroceryListItemAdded>((event, emit) {
      GroceryList groceryList = state.groceryList;
      groceryList.addItem(event.item);
      emit(state.copyWith(groceryList: groceryList));
    });
  }
}
