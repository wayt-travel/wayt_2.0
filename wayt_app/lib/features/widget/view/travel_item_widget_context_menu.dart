import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/context/context.dart';
import '../../../widgets/modal/modal.dart';
import 'travel_item_widget.dart';

/// The steps to determine the position of the context menu on the y-axis
/// based on the tap position.
///
/// Given two values [a,b], the context menu is displayed:
/// - below the tap if the tap is in the above (a*100)% of the screen
/// - above the tap if the tap is in the below (b*100)% of the screen
/// - otherwise the context menu is y-centered on the tap position.
///
/// E.g., if [a,b] = [.4, .6], the context menu is displayed:
/// - below the tap if the tap is in the above 40% of the screen
/// - above the tap if the tap is in the below 60% of the screen
/// - otherwise the context menu is y-centered on the tap position.
const _ySteps = [.4, .6];

/// Same as [_ySteps] but for the x-axis.
const _xSteps = [.25, .75];

/// A context menu for a [TravelItemWidget].
class TravelItemWidgetContextMenu extends StatelessWidget {
  final List<ModalBottomSheetAction> actions;

  /// Computes the position of the context menu based on the tap position.
  static ({
    Alignment? animationAlignment,
    double? bottom,
    double? left,
    Offset offset,
    double? right,
    double? top,
  }) _computePosition({
    required BuildContext context,
    required Offset position,
  }) {
    final x = position.dx;
    final y = position.dy;
    final w = context.mq.size.width;
    final h = context.mq.size.height;
    final margin = $.style.insets.xs;

    Alignment? animationAlignment;
    double? top;
    double? bottom;
    late final double yOffset;

    if (y < h * _ySteps[0]) {
      // show below the tap
      top = y + margin;
      yOffset = 0;
      animationAlignment = Alignment.topCenter;
    } else if (y > h * _ySteps[1]) {
      // show above the tap
      bottom = h - y + margin;
      yOffset = 0;
      animationAlignment = Alignment.bottomCenter;
    } else {
      top = y;
      yOffset = -.5;
    }

    double? left;
    double? right;
    late final double xOffset;

    if (x < w * _xSteps[0]) {
      // show to the right of the tap
      left = x + margin;
      xOffset = 0;
      if (animationAlignment == null) {
        animationAlignment = Alignment.centerLeft;
      } else if (animationAlignment == Alignment.topCenter) {
        animationAlignment = Alignment.topLeft;
      } else if (animationAlignment == Alignment.bottomCenter) {
        animationAlignment = Alignment.bottomLeft;
      }
    } else if (x > w * _xSteps[1]) {
      // show to the left of the tap
      right = w - x + margin;
      xOffset = 0;
      if (animationAlignment == null) {
        animationAlignment = Alignment.centerRight;
      } else if (animationAlignment == Alignment.topCenter) {
        animationAlignment = Alignment.topRight;
      } else if (animationAlignment == Alignment.bottomCenter) {
        animationAlignment = Alignment.bottomRight;
      }
    } else {
      left = w / 2;
      xOffset = -.5;
    }
    return (
      animationAlignment: animationAlignment,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      offset: Offset(xOffset, yOffset),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required Offset position,
    required List<ModalBottomSheetAction> actions,
  }) =>
      context.navRoot.push(
        PageRouteBuilder<void>(
          reverseTransitionDuration: $.style.times.fastest,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (context, _, __) {
            final (:animationAlignment, :top, :bottom, :left, :right, :offset) =
                _computePosition(
              context: context,
              position: position,
            );
            return GestureDetector(
              onTap: () => context.navRoot.pop(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Positioned(
                      top: top,
                      bottom: bottom,
                      left: left,
                      right: right,
                      child: FractionalTranslation(
                        translation: offset,
                        child: Animate(
                          effects: [
                            ScaleEffect(
                              duration: $.style.times.fastest,
                              alignment: animationAlignment,
                            ),
                          ],
                          child: TravelItemWidgetContextMenu(actions),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          barrierColor: Colors.black38,
          barrierDismissible: true,
          opaque: false,
          transitionDuration: Duration.zero,
        ),
      );

  const TravelItemWidgetContextMenu(this.actions, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      // Use material so that the list tile shows ripple effect on it.
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: context.col.surfaceContainerHigh,
        borderRadius: $.style.corners.md.asBorderRadius,
        child: Column(
          children: actions
              .map((action) => ModalBottomSheetTile(action: action))
              .toList(),
        ),
      ),
    );
  }
}
