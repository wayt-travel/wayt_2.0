import 'package:flutter/material.dart';

/// A widget that displays a blinking dot animation.
class BlinkingDot extends StatefulWidget {
  /// The color of the dot.
  final Color color;

  /// The size of the dot.
  final double size;

  /// The minimum scale of the dot when it is blinking.
  final double minSizeScale;

  /// Creates a new instance of [BlinkingDot].
  const BlinkingDot({
    required this.color,
    this.size = 15,
    this.minSizeScale = 0.5,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with TickerProviderStateMixin {
  late Tween<double> _tween;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tween = Tween<double>(
      begin: widget.minSizeScale,
      end: 1,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOutQuad,
        ),
      ),
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.color,
        ),
      ),
    );
  }
}
