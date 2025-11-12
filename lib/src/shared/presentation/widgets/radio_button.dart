import 'package:flutter/material.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart';

class RadioOption<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T groupValue;
  final T value;
  final void Function(T?)? onChanged;

  const RadioOption({
    super.key,
    required this.title,
    this.subtitle,
    required this.groupValue,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text.rich(
        TextSpan(text: title, style: AppTextStyles.radioOptionTitle, children: [
          if (subtitle != null)
            TextSpan(
              text: " $subtitle",
              style: AppTextStyles.radioOptionSubtitle,
            ),
        ]),
      ),
      activeColor: AppColors.accent,
    );
  }
}
