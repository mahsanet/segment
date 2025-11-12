import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxy_core/proxy_core.dart';
import 'package:segment/src/shared/constants/app_theme.dart';
import 'package:segment/src/shared/errors/error_logger.dart';
import 'package:segment/src/shared/errors/error_observer.dart';
//ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void bootstrap({
  required FutureOr<Widget> Function() builder,
}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    ProxyCore.ins
        .setIosTunnelInfo("Segment", "com.mahsanet.segment.PacketTunnel");

    // TODO: Handle here if the new theme (Dark Mode) added to the app
    SystemChrome.setSystemUIOverlayStyle(AppTheme.lightSystemOverlayStyle);

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) return stack.vmTrace;
      if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
      return stack;
    };

    // TODO: Handle first run-related actions here
    // final isFirstRun = await SharedPrefsRepo().isFirstRun();
    //
    //       if (isFirstRun) {
    //         await SecureStorage().deleteAll().runOrThrow();
    //         await SharedPreferencesRepo().setFirstRunToFalse().runOrThrow();
    //       }
    //
    //
    //       final path = (await getApplicationDocumentsDirectory()).path;
    //       Hive.init(path);

    // final selectedMode = await SharedPrefsRepo().selectedConnectionMode();

    final container = ProviderContainer(
      overrides: [
        // envProvider.overrideWithValue(env),
        // connectionModeProvider.overrideWith((_) => selectedMode),
        // TODO: IF ANY ...await _getHiveOverrides(),
      ],
      observers: [
        ErrorObserver(),
      ],
    );

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      container
          .read(errorLoggerProvider)
          .logError(details.exception, details.stack);
    };

    runApp(
      UncontrolledProviderScope(container: container, child: await builder()),
    );

    // Windows app frame configs
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        const initialSize = Size(450, 800);
        appWindow.minSize = initialSize;
        appWindow.size = initialSize;
        appWindow.maxSize = initialSize;
        appWindow.alignment = Alignment.center;
        appWindow.title = "Segment";
        appWindow.show();
      });
    }
  }, (error, stackTrace) => ErrorLogger().logError(error, stackTrace));
}
