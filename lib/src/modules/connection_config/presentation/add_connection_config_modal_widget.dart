import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/l10n/l10n.dart';
import 'package:segment/src/modules/connection_config/presentation/widgets/connection_config_input.dart';
import 'package:segment/src/modules/connection_config/presentation/widgets/connection_config_input_controller.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart'; // Import the text styles
import 'package:segment/src/shared/presentation/widgets/custom_dialog.dart';

/// Shows the add subscription modal dialog with animation
Future<void> showConnectionConfigModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => DialogScaffold(
      child: const AddConnectionConfigModalWidget(),
    ),
  );
}

/// A modal widget for adding subscription information
class AddConnectionConfigModalWidget extends ConsumerWidget {
  const AddConnectionConfigModalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(connectionConfigControllerProvider);

    return Material(
      color: AppColors.transparent,
      child: Center(
        child: Container(
          width: 300.w,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(10),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.wordImport,
                  style: AppTextStyles.modalHeader, // Use the extracted style
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.noConfigImportedText,
                  style:
                      AppTextStyles.modalDescription, // Use the extracted style
                ),
                SizedBox(height: 16.h),
                const ConnectionConfigInput(),
                SizedBox(height: 20.h),
                _buildActionButtons(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCancelButton(context),
        _buildSubmitButton(context, ref),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      icon: AppIcons.arrowBackIos,
      label: Text(
        context.l10n.neverMind,
        style: AppTextStyles.modalButtonText, // Use the extracted style
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: Navigator.of(context).pop,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      ),
      child: Text(
        context.l10n.wordSubmit,
        style: AppTextStyles.modalSubmitButtonText, // Use the extracted style
      ),
    );
  }
}
