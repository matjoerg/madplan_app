import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/blocs/dish/dish_bloc.dart';
import 'package:madplan_app/data/models/models.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository databaseRepository;
  final DishBloc dishBloc;
  late StreamSubscription dishSubscription;

  DatabaseBloc({
    required this.databaseRepository,
    required this.dishBloc,
  }) : super(DatabaseInitial()) {
    dishSubscription = dishBloc.stream.listen((state) {
      if (state is DishSavedSuccess) {
        add(DatabaseAppStarted());
      }
    });

    on<DatabaseAppStarted>((event, emit) async {
      emit(DatabaseLoading());
      try {
        await databaseRepository.databaseIsReady();

        List<Dish> dishes = await databaseRepository.getDishes();
        List<Item> items = await databaseRepository.getItems();
        List<Category> categories = await databaseRepository.getCategories();
        emit(DatabaseLoaded(
          dishes: dishes,
          items: items,
          categories: categories,
        ));
      } catch (_) {
        emit(DatabaseError());
      }
    });
  }

  @override
  Future<void> close() {
    dishSubscription.cancel();
    return super.close();
  }
}
