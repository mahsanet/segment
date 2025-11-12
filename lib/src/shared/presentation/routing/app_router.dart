import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:segment/src/modules/logs/presentation/logs_screen.dart';
import 'package:segment/src/modules/main/presentation/main_screen.dart';
import 'package:segment/src/shared/errors/error_logger.dart';
import 'package:segment/src/shared/presentation/routing/shell_route_widget.dart';

part 'app_router.g.dart';

const mainScreenName = "main";
const logsScreenName = "logs";
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/$mainScreenName",
    navigatorKey: rootNavigatorKey,
    onException: (context, state, router) => ref
        .read(errorLoggerProvider)
        .logError(state.error!, StackTrace.current),
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ShellRouteWidget(child: child),
        routes: $appRoutes,
      ),
    ],
  );
});

/// main route ---------------------------------------------------------------
@TypedGoRoute<MainRoute>(
    name: mainScreenName,
    path: "/$mainScreenName",
    routes: [
      TypedGoRoute<LogsRoute>(
        name: logsScreenName,
        path: logsScreenName,
      ),
    ])
class MainRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const MainScreen();
}

class LogsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const LogsScreen();
}
