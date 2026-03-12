import '/ui/DetailScreen/DetailScreen.dart';
import '/ui/HomeScreen/HomeScreen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(
      path: '/users/:userId',
      builder: (context, state) =>
          DetailScreen(userId: state.pathParameters['userId']!),
    ),
  ],
);
