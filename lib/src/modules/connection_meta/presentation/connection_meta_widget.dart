// Add this to your main_screen.dart file
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/modules/connection_meta/presentation/connection_meta_controller.dart';
import 'package:segment/src/modules/main/presentation/main_controller.dart';
import 'package:segment/src/modules/main/presentation/widgets/main_row_item.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/constants/app_sizes.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart';
import 'package:segment/src/shared/utils/async_value_extensions.dart';

class ConnectionMetaWidget extends ConsumerWidget {
  const ConnectionMetaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionMetaAsync = ref.watch(connectionMetaControllerProvider);

    return MainRowItem(
      child: Row(
        children: [
          if (connectionMetaAsync != null) ...[
            Text(
              connectionMetaAsync.flagEmoji,
              style: AppTextStyles.ipAddressText,
            ),
            SizedBox(width: 12.w),
            Text(
              connectionMetaAsync.ip,
              style: AppTextStyles.ipAddressText,
            ),
          ] else ...[
            AppIcons.loadingIndicator(size: 15.r),
            SizedBox(width: 12.w),
            Text(
              'Loading...',
              style: AppTextStyles.ipAddressText,
            ),
          ],
          const Spacer(),
          // TODO: Ping text should be here
          // Text(
          //   '132ms',
          //   style: AppTextStyles.pingText,
          // ),
          SizedBox(width: AppSizes.p12),
          InkWell(
            onTap: () async {
              final testResult = await ref
                  .read(mainControllerProvider.notifier)
                  .testAfterConnected();
              testResult.showSnackBar(context);
            },
            child: connectionMetaAsync != null
                ? AppIcons.refresh(width: 16.r, height: 16.r)
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
