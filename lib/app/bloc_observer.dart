import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint('${bloc.runtimeType}: Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    String current = transition.currentState.toString();
    String event = transition.event.toString();
    String next = transition.nextState.toString();
    debugPrint("${bloc.runtimeType}: \n\tcurrent: $current\n\tevent: $event\n"
        "\tnext: "
        "$next");
    super.onTransition(bloc, transition);
  }
}
