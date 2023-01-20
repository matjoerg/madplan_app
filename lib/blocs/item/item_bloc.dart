import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/data/models/models.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final DatabaseRepository databaseRepository;

  ItemBloc({required this.databaseRepository}) : super(ItemInitial()) {

    on<ItemAdded>((event, emit) async {
      emit(ItemLoading());
      try {
        await databaseRepository.saveItem(event.ingredient);
        emit(ItemSavedSuccess());
      } catch (e, s) {
        emit(ItemError());
      }
    });

    on<ItemCategoryAdded>((event, emit) async {
      emit(ItemLoading());
      try {
        await databaseRepository.saveCategory(event.categoryName);
        emit(ItemCategorySavedSuccess());
      } catch (e, s) {
        emit(ItemError());
      }
    });
  }
}
