import 'package:go_router/go_router.dart';
import '../../app_state.dart';
import '../../pages/login_page/login_page_widget.dart';
import '../../pages/signup_page/signup_page_widget.dart';
import '../../pages/home_page/home_page_widget.dart';
import '../../pages/create_edit_todo_page/create_edit_todo_page_widget.dart';

GoRouter createRouter(FFAppState appState) => GoRouter(
      refreshListenable: appState,
      initialLocation: '/login',
      redirect: (context, state) {
        final loggedIn = appState.isLoggedIn;
        final onAuthPage = state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';
        if (!loggedIn && !onAuthPage) return '/login';
        if (loggedIn && onAuthPage) return '/home';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'LoginPage',
          builder: (context, state) => const LoginPageWidget(),
        ),
        GoRoute(
          path: '/signup',
          name: 'SignupPage',
          builder: (context, state) => const SignupPageWidget(),
        ),
        GoRoute(
          path: '/home',
          name: 'HomePage',
          builder: (context, state) => const HomePageWidget(),
        ),
        GoRoute(
          path: '/create-todo',
          name: 'CreateEditTodoPage',
          builder: (context, state) {
            final todo = state.extra as Map<String, dynamic>?;
            return CreateEditTodoPageWidget(existingTodo: todo);
          },
        ),
      ],
    );
