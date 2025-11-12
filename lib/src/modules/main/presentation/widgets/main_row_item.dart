import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_sizes.dart';

class MainRowItem extends StatelessWidget {
  final Widget child;

  const MainRowItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.white,
        ),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: child,
          ),
        ),
      ),
    );
  }
}
