import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/models/item.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemIdle()) {
    on<ItemEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
