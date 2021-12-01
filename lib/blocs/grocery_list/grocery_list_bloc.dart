import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/models/grocery_list.dart';
import 'package:madplan_app/models/item.dart';
import 'package:madplan_app/models/meal_plan.dart';

part 'grocery_list_event.dart';
part 'grocery_list_state.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  GroceryListBloc() : super(GroceryListLoaded(groceryList: GroceryList.empty())) {
    on<GroceryListCreated>((event, emit) {
      emit(GroceryListLoaded(
        groceryList: GroceryList(
          items: {
            "Frugt og grønt": [
              Item(name: "Kartofler", category: "Frugt og grønt"),
              Item(name: "Bananer", category: "Frugt og grønt"),
            ],
            "Kolonial": [
              Item(name: "Havregryn", category: "Kolonial"),
              Item(name: "Rugbrød", category: "Kolonial"),
            ]
          },
        ),
      ));
    });
  }
}
