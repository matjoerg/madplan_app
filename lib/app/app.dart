import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madplan_app/blocs/database/database_bloc.dart';
import 'package:madplan_app/blocs/dish/dish_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
import 'package:madplan_app/blocs/item/item_bloc.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';
import 'package:madplan_app/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviderList,
      child: Theme(
        data: ThemeData(
          splashFactory: NoSplash.splashFactory,
        ),
        child: const CupertinoApp(
          theme: CupertinoThemeData(
            brightness: Brightness.light,
          ),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeScreen(),
        ),
      ),
    );
  }
}

final List<BlocProvider> blocProviderList = [
  BlocProvider<DishBloc>(
    create: (BuildContext context) => DishBloc(
      databaseRepository: DatabaseRepository(),
    ),
  ),
  BlocProvider<ItemBloc>(
    create: (BuildContext context) => ItemBloc(
      databaseRepository: DatabaseRepository(),
    ),
  ),
  BlocProvider<DatabaseBloc>(
    lazy: false,
    create: (BuildContext context) => DatabaseBloc(
      databaseRepository: DatabaseRepository(),
      dishBloc: BlocProvider.of<DishBloc>(context),
      itemBloc: BlocProvider.of<ItemBloc>(context),
    )..add(DatabaseAppStarted()),
  ),
  BlocProvider<GroceryListBloc>(
    create: (BuildContext context) => GroceryListBloc(
      databaseBloc: BlocProvider.of<DatabaseBloc>(context),
    ),
  ),
];
