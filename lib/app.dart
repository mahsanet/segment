import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/l10n/arb/app_localizations.dart';
import 'package:segment/src/l10n/l10n.dart';
import 'package:segment/src/shared/constants/app_theme.dart';
import 'package:segment/src/shared/presentation/routing/app_router.dart';
import 'package:segment/src/shared/presentation/widgets/windows_specific_wrapper.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.read(goRouterProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.radius,
      builder: (context, child) => MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: AppTheme.appTheme,
        builder: (context, child) =>
            Platform.isWindows ? WindowsSpecificWrapper(child: child!) : child!,
      ),
    );
  }
}
