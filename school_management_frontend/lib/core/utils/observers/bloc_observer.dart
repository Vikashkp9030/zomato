import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final logger = Logger();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.i('BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.i('Event: ${event.runtimeType} - ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i(
      'Transition: ${transition.currentState.runtimeType} → '
      '${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('Error in ${bloc.runtimeType}: $error', stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
