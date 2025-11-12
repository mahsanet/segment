import 'package:flutter/material.dart';
import 'package:segment/src/shared/constants/app_colors.dart';

class DialogScaffold extends StatelessWidget {
  final Widget child;

  const DialogScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: AnimatedDialogContent(
        child: child,
      ),
    );
  }
}

/// Handles the animations for dialog content
class AnimatedDialogContent extends StatelessWidget {
  final Widget child;

  const AnimatedDialogContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ModalRoute.of(context)!.animation!,
      builder: (context, _) {
        final animation = ModalRoute.of(context)!.animation!;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return Stack(
          children: [
            // Dismissible overlay
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox.expand(),
            ),

            // Gradient background
            _buildAnimatedBackground(curvedAnimation),

            // Animated modal
            _buildAnimatedModal(curvedAnimation, child),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedBackground(Animation<double> animation) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.accent
                      .withAlpha((0.6 * animation.value * 255).round()),
                  AppColors.accent
                      .withAlpha((0.5 * animation.value * 255).round()),
                  AppColors.accent
                      .withAlpha((0.3 * animation.value * 255).round()),
                  AppColors.accent
                      .withAlpha((0.1 * animation.value * 255).round()),
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedModal(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.1, 1.0),
          ),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
          child: child,
        ),
      ),
    );
  }
}
