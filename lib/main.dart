import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madplan_app/screens/home_screen.dart';
import 'package:madplan_app/services/service_locator.dart';

import 'blocs/grocery_list/grocery_list_bloc.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviderList,
      child: CupertinoApp(
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
    );
  }
}

final List<BlocProvider> blocProviderList = [
  BlocProvider<GroceryListBloc>(
    create: (BuildContext context) => GroceryListBloc(),
  ),
];
