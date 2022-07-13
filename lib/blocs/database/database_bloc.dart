import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      await databaseRepository.databaseIsReady();

      await databaseRepository.getDishes();
    });
  }
}
