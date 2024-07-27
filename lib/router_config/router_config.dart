import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';

import '../core/helpers/ui_helpers.dart';
import '../di.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/presentation/pages/auth_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

BuildContext get kContext => _rootNavigatorKey.currentContext!;
final kScaffoldMessengerKey = sl<GlobalKey<ScaffoldMessengerState>>();

enum Routes {
  auth(name: 'auth', path: '/'),
  home(name: 'home', path: '/home');

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final GoRouter router = GoRouter(
  initialLocation: _getInitialRoute(),
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: Routes.auth.name,
      path: Routes.auth.path,
      pageBuilder: (context, state) => _buildPage(
        state.pageKey,
        state.name!,
        const AuthPage(),
      ),
    ),
    GoRoute(
      name: Routes.home.name,
      path: Routes.home.path,
      pageBuilder: (context, state) => _buildPage(
        state.pageKey,
        state.name!,
        const HomePage(),
      ),
    ),
  ],
);

Page<MaterialPage> _buildPage(LocalKey key, String name, Widget child) {
  return MaterialPage(
    key: key,
    name: name,
    child: GestureDetector(
      onTap: UiHelpers.removeFocus,
      child: child,
    ),
  );
}

String _getInitialRoute() {
  if (sl<AuthLocalDatasource>().isAuthenticated()) {
    return Routes.home.path;
  }
  return Routes.auth.path;
}
