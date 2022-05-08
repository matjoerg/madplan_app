import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madplan_app/presentation/screens/home_screen.dart';
import 'package:madplan_app/data/services/service_locator.dart';

import 'blocs/grocery_list/grocery_list_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = serviceLocator.get<DatabaseService>();
    db.isOpen();
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
  BlocProvider<GroceryListBloc>(
    create: (BuildContext context) => GroceryListBloc(),
  ),
];
