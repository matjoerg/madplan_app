import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madplan_app/data/models/dish.dart';
import 'package:madplan_app/data/models/item.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository databaseRepository;

  DatabaseBloc({
    required this.databaseRepository,
  }) : super(DatabaseInitial()) {

    on<DatabaseAppStarted>((event, emit) async {
      emit(DatabaseLoading());
      try {
        await databaseRepository.databaseIsReady();

        List<Dish> dishes = await databaseRepository.getDishes();
        List<Item> items = await databaseRepository.getItems();
        emit(DatabaseLoaded(
          dishes: dishes,
          items: items,
        ));
      } catch (_) {
        emit(DatabaseError());
      }
    });
  }
}
