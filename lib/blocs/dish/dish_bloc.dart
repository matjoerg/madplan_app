import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/data/models/models.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';

part 'dish_event.dart';
part 'dish_state.dart';

class DishBloc extends Bloc<DishEvent, DishState> {
  final DatabaseRepository databaseRepository;
  late StreamSubscription databaseSubscription;

  DishBloc({required this.databaseRepository}) : super(DishInitial()) {
    on<DishSaved>((event, emit) async {
      emit(DishLoading());
      try {
        await databaseRepository.saveDish(event.dish);
        emit(DishSavedSuccess());
      } catch (e, s) {
        emit(DishError());
      }
    });
  }
}
