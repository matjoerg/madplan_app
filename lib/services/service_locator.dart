import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<CupertinoTabController>(CupertinoTabController());
}
