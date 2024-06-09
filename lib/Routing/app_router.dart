import 'package:erpmobile/Routing/router_names.dart';
import 'package:erpmobile/Services/authe_service.dart';
import 'package:erpmobile/login.dart';
import 'package:erpmobile/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    bool isAuthenticated = await AuthService().isAuthenticated();
    if (isAuthenticated) {
      return null;
    } else {
      return '/$RouterNames.login';
    }
  },
  routes: [
    GoRoute(
        path: '/',
        name: RouterNames.home,
        pageBuilder: (context, state) => MaterialPage(child: HomeScreen())),
    GoRoute(
        path: '/$RouterNames.login',
        name: RouterNames.login,
        pageBuilder: (context, state) => const MaterialPage(child: LogIn())),
  ],
);
