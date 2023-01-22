import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/data/services/service_locator.dart';

import 'app/app.dart';
import 'app/bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  BlocOverrides.runZoned(
        () {
      runApp(const App());
    },
    blocObserver: MyBlocObserver(),
  );
}