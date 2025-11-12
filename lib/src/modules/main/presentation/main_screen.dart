import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/gen/assets.gen.dart';
import 'package:segment/src/l10n/l10n.dart';
import 'package:segment/src/modules/connection_config/data/connection_config_repo.dart';
import 'package:segment/src/modules/connection_config/presentation/add_connection_config_modal_widget.dart';
import 'package:segment/src/modules/connection_config/presentation/widgets/connection_config_input_controller.dart';
import 'package:segment/src/modules/connection_meta/presentation/connection_meta_controller.dart';
import 'package:segment/src/modules/connection_meta/presentation/connection_meta_widget.dart';
import 'package:segment/src/modules/core/data/core_repo.dart';
import 'package:segment/src/modules/main/presentation/main_controller.dart';
import 'package:segment/src/modules/main/presentation/widgets/main_connect_button/main_connect_button.dart';
import 'package:segment/src/modules/main/presentation/widgets/main_row_item.dart';
import 'package:segment/src/modules/settings/presention/settings_modal_widget.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart';
import 'package:segment/src/shared/presentation/routing/app_router.dart';
import 'package:segment/src/shared/utils/async_value_extensions.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        image: DecorationImage(
          image: Assets.images.bg.image(fit: BoxFit.cover).image,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: AppIcons.logo(),
          ),
          actions: [
            IconButton(
              iconSize: 28,
              icon: AppIcons.bug(width: 30.h, height: 30.h),
              onPressed: () {
                ref.read(goRouterProvider).goNamed(logsScreenName);
              },
            ),
            IconButton(
              iconSize: 28,
              icon: AppIcons.settings(width: 30.h, height: 30.h),
              onPressed: () => showSettingsModal(context),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconButton(
                  iconSize: 28,
                  icon: AppIcons.circlePlus(width: 30.h, height: 30.h),
                  onPressed: () => showConnectionConfigModal(context)),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: _MainScreenContent(),
        ),
      ),
    );
  }
}

class _MainScreenContent extends ConsumerWidget {
  const _MainScreenContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilds when connection config changes
    ref.watch(connectionConfigControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 0.075.sh),
        MainScreenHint(),
        const Spacer(),
        ConnectionButton(),
        SizedBox(height: 0.125.sh),
      ],
    );
  }
}

class MainScreenHint extends ConsumerWidget {
  const MainScreenHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainState = ref.watch(mainControllerProvider);
    // Rebuilds when core status changes
    final coreStatus = ref.watch(isCoreRunningProvider).value ?? false;
    final config = ref.read(connectionConfigRepoProvider).config;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIcons.cloudCheck(width: 150.w, height: 150.h),
          SizedBox(height: 30.h),
          Text(
            context.l10n.hasActiveSub_MainScreen,
            textAlign: TextAlign.center,
            // TODO: This text style should be here as defining it it in the [AppTextStyles] causes the text to not show
            // Equivalent in the [AppTextStyles] is mainScreenHint
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 30.h),
          InkWell(
            highlightColor: AppColors.transparent,
            splashColor: AppColors.transparent,
            onTap: () => showConnectionConfigModal(context),
            child: MainRowItem(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      config?.configName ?? context.l10n.addYourConfig,
                      overflow: TextOverflow.ellipsis,
                      // TODO: This text style should be here as defining it it in the [AppTextStyles] causes the text to not show
                      // Equivalent in the [AppTextStyles] is configText
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black54,
                      ),
                    ),
                  ),
                  AppIcons.chevronRight,
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          mainState.when(
            data: (state) {
              if (state == MainState.connected && coreStatus) {
                return ConnectionMetaWidget();
              } else {
                return SizedBox.shrink();
              }
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class ConnectionButton extends ConsumerWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainState = ref.watch(mainControllerProvider);
    final mainController = ref.read(mainControllerProvider.notifier);
    final isCoreRunning = ref.watch(isCoreRunningProvider).value ?? false;
    final connectionMetaController =
        ref.read(connectionMetaControllerProvider.notifier);

    return MainConnectButton(
        width: 0.725.sw,
        height: 0.175.sw,
        isConnected: mainState.maybeWhen(
          data: (state) => state == MainState.connected && isCoreRunning,
          orElse: () => false,
        ),
        onSlideComplete: () async {
          final connectResult = await mainController.connect();
          connectResult.showSnackBarOnError(context);
          debugPrint(connectResult.toString());
          if (connectResult is AsyncData) {
            final testResult = await mainController.testAfterConnected();
            testResult.showSnackBar(context);
            if (testResult is AsyncData) {
              connectionMetaController.fetchConnectionMeta();
            }
          }
        },
        onToggle: () {
          // Clear connection metadata when disconnecting
          connectionMetaController.clear();
          mainController.disconnect();
        });
  }
}
