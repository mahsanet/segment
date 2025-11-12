import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/modules/connection_config/presentation/widgets/connection_config_input_controller.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart'; // Import text styles

class ConnectionConfigInput extends ConsumerWidget {
  const ConnectionConfigInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputState = ref.watch(connectionConfigControllerProvider);
    final configController =
        ref.read(connectionConfigControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: inputState.input)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: inputState.input.length),
                ),
              onChanged: configController.updateInput,
              enabled: !inputState.isDisabled,
              decoration: InputDecoration(
                hintText: 'Paste config link/json here',
                isDense: true,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                hintStyle: AppTextStyles.inputHintText,
                // Use extracted style
                errorText: inputState.error,
              ),
              style: AppTextStyles.inputText, // Use extracted style
            ),
          ),
          IconButton(
            icon: AppIcons.deleteOutline(size: 20.r),
            onPressed:
                inputState.isDisabled ? null : configController.clearInput,
          ),
        ],
      ),
    );
  }
}
