import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/l10n/arb/app_localizations.dart';
import 'package:segment/src/l10n/l10n.dart';
import 'package:segment/src/modules/main/presentation/widgets/main_connect_button/main_connect_button_timer_controller.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_icons.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart';

class MainConnectButton extends ConsumerStatefulWidget {
  const MainConnectButton({
    super.key,
    this.width = 300.0,
    this.height = 70.0,
    required this.isConnected,
    this.onSlideComplete,
    this.onSlideStart,
    this.onToggle,
  });

  final double width;
  final double height;
  final bool isConnected;
  final Future<void> Function()? onSlideComplete;
  final VoidCallback? onSlideStart;
  final VoidCallback? onToggle;

  @override
  ConsumerState<MainConnectButton> createState() => _MainConnectButtonState();
}

class _MainConnectButtonState extends ConsumerState<MainConnectButton>
    with SingleTickerProviderStateMixin {
  // Constants
  static const _animationDuration = Duration(milliseconds: 200);
  static const _slidePadding = 5.0;
  static const _minDragDistance = 10.0;
  static const _disconnectThreshold = 0.7;
  static const _connectThreshold = 0.7;

  // Animation controllers
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // Drag state
  double _dragPosition = 0.0;
  bool _isDragging = false;
  bool _isLoading = false;
  bool _isDisconnectingDrag = false;
  Offset _dragStartPosition = Offset.zero;

  double get _borderRadius => 50.r;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _updateConnectionState(widget.isConnected);
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        if (!_isDragging) {
          setState(() {
            _dragPosition = _animation.value;
          });
        }
      });
  }

  void _updateConnectionState(bool isConnected) {
    if (isConnected) {
      _dragPosition = 1.0;
      _updateTimerConnectionStatus(true);
    }
  }

  void _updateTimerConnectionStatus(bool isConnected) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(connectionTimerProvider.notifier)
          .updateConnectionStatus(isConnected: isConnected);
    });
  }

  @override
  void didUpdateWidget(MainConnectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      _updateConnectionState(widget.isConnected);
      if (!widget.isConnected) {
        _updateTimerConnectionStatus(false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Drag handlers
  void _onDragStart(DragStartDetails details) {
    if (_isLoading) return;

    _dragStartPosition = details.globalPosition;
    setState(() {
      _isDragging = true;
      _isDisconnectingDrag = widget.isConnected;
    });

    widget.onSlideStart?.call();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isLoading) return;
    final dragDistance = (details.globalPosition - _dragStartPosition).dx.abs();
    if (dragDistance < _minDragDistance) return;

    final slidableDistance = widget.width - widget.height;
    setState(() {
      if (_isDisconnectingDrag) {
        // When disconnecting, drag moves right to left
        _dragPosition = (_dragPosition - details.delta.dx / slidableDistance)
            .clamp(0.0, 1.0);
      } else {
        // When connecting, drag moves left to right
        _dragPosition = (_dragPosition + details.delta.dx / slidableDistance)
            .clamp(0.0, 1.0);
      }
    });
  }

  void _onDragEnd(DragEndDetails details) async {
    _isDragging = false;
    if (_isDisconnectingDrag) {
      if (_dragPosition > _disconnectThreshold) {
        _handleDisconnect();
      } else {
        _putBackToWhereItWas();
      }
    } else {
      if (_dragPosition > _connectThreshold) {
        await _handleConnect();
      } else {
        _putBackToWhereItWas();
      }
    }
  }

  void _onTap() {
    if (_isLoading) return;

    if (widget.isConnected) {
      _handleDisconnect();
    }
  }

  // State transitions
  Future<void> _handleConnect() async {
    setState(() {
      _isLoading = true;
      _dragPosition = 1.0;
    });

    try {
      await widget.onSlideComplete?.call();
      if (mounted) {
        if (widget.isConnected) {
          _updateTimerConnectionStatus(true);
        } else {
          _putBackToWhereItWas();
        }
      }
    } catch (_) {
      if (mounted) _putBackToWhereItWas();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleDisconnect() {
    _updateTimerConnectionStatus(false);
    widget.onToggle?.call();
    _putBackToWhereItWas();
  }

  void _putBackToWhereItWas() {
    _controller.value = _dragPosition;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final slidableDistance = widget.width - widget.height;
    final slideOffset = _calculateSlideOffset(slidableDistance);
    final l10n = context.l10n;
    final connectionTimerState = ref.watch(connectionTimerProvider);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Stack(
        children: [
          if (widget.isConnected == false) _buildRightArrows(),
          if (widget.isConnected && !_isLoading)
            _buildConnectionInfo(l10n, connectionTimerState.activeTime),
          _buildSlideButton(slideOffset),
        ],
      ),
    );
  }

  Widget _buildRightArrows() {
    return Positioned(
      right: 20,
      top: 0,
      bottom: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.chevronsRightLowContrast(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionInfo(AppLocalizations l10n, Duration activeTime) {
    return Positioned(
      left: 20,
      top: 0,
      bottom: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.activeTimeText,
                style: AppTextStyles.activeTimeLabel,
              ),
              Text(
                _formatDuration(activeTime),
                style: AppTextStyles.activeTimeValue,
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSlideButton(double slideOffset) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: widget.height,
        width: widget.width,
        color: AppColors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: slideOffset,
              top: _slidePadding,
              child: Container(
                height: widget.height - (_slidePadding * 2),
                width: widget.height - (_slidePadding * 2),
                decoration: BoxDecoration(
                  color: _getButtonColor(),
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: _getIcon()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  double _calculateSlideOffset(double slidableDistance) {
    if (widget.isConnected) {
      return _isDisconnectingDrag
          ? slidableDistance * (1.0 - _dragPosition) + _slidePadding
          : slidableDistance + _slidePadding;
    } else {
      return slidableDistance * _dragPosition + _slidePadding;
    }
  }

  Color _getBackgroundColor() {
    if (_isLoading) {
      return const Color(0xffffefd3);
    } else if (widget.isConnected) {
      return AppColors.greenShadow;
    } else {
      return AppColors.itemsBackground;
    }
  }

  Color _getButtonColor() {
    return widget.isConnected && !_isLoading
        ? AppColors.green
        : AppColors.white;
  }

  Widget _getIcon() {
    if (_isLoading) {
      return const SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
        ),
      );
    } else if (widget.isConnected) {
      return AppIcons.check;
    } else {
      return AppIcons.bolt();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
