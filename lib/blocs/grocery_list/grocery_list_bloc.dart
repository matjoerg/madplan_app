import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/models/meal_plan.dart';

part 'grocery_list_event.dart';
part 'grocery_list_state.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  GroceryListBloc() : super(GroceryListInitial()) {
    on<GroceryListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
