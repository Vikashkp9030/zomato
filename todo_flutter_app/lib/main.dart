import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = FFAppState();
  await appState.initializePersistedState();
  runApp(
    ChangeNotifierProvider<FFAppState>.value(
      value: appState,
      child: TodoApp(appState: appState),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.appState});
  final FFAppState appState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(appState),
    );
  }
}
