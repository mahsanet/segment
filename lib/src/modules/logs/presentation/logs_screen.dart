import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/modules/logs/presentation/logs_controller.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/presentation/routing/app_router.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsState = ref.watch(logsControllerProvider);
    final String logsValue = logsState.value ?? '';

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: AppIcons.logo(),
          ),
          centerTitle: false,
          actions: [
            if (logsValue.isNotEmpty)
              IconButton(
                icon: AppIcons.copy(width: 25.h, height: 25.h),
                onPressed: () {
                  if (logsValue.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: logsValue));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logs copied to clipboard")),
                    );
                  }
                },
              ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconButton(
                  iconSize: 36,
                  icon: AppIcons.back(width: 36.h, height: 36.h),
                  onPressed: ref.read(goRouterProvider).pop),
            ),
          ],
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 75.w),
                child: logsState.when(
                  data: (logs) {
                    final logLines = logs.trim().split('\n\n');
                    return logs.isEmpty
                        ? Column(children: [
                            AppIcons.emptyLog(width: 100.w, height: 100.h),
                            SizedBox(height: 15.h),
                            Text(
                              'There are no logs to display.',
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              logLines.length,
                              (index) => Container(
                                padding: EdgeInsets.all(7.5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  color: index % 2 == 0
                                      ? Colors.transparent
                                      : Colors.grey.shade200,
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.w),
                                  child: Text(
                                    logLines[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                  loading: () => Text(
                    'Connect to see logs.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Error loading logs: $e',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: logsValue.isNotEmpty
            ? SizedBox(
                height: 60.w,
                width: 60.w,
                child: FittedBox(
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: AppColors.lightGrey,
                    child: AppIcons.eraser(width: 27.w, height: 27.w),
                    onPressed: () {
                      ref.read(logsControllerProvider.notifier).clearLogs();
                    },
                  ),
                ),
              )
            : null);
  }
}
