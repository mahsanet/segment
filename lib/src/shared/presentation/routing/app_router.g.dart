// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $mainRoute,
    ];

RouteBase get $mainRoute => GoRouteData.$route(
      path: '/main',
      name: 'main',
      factory: $MainRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'logs',
          name: 'logs',
          factory: $LogsRoute._fromState,
        ),
      ],
    );

mixin $MainRoute on GoRouteData {
  static MainRoute _fromState(GoRouterState state) => MainRoute();

  @override
  String get location => GoRouteData.$location(
        '/main',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LogsRoute on GoRouteData {
  static LogsRoute _fromState(GoRouterState state) => LogsRoute();

  @override
  String get location => GoRouteData.$location(
        '/main/logs',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
