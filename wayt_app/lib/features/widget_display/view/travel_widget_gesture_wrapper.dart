import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;

import '../../../repositories/repositories.dart';
import '../../features.dart';

/// A function that shows a context menu for a travel widget.
typedef TravelWidgetShowContextMenu = void Function(
  BuildContext context,
  Offset globalPosition,
);

/// A function that overrides the default behavior of a travel widget gesture.
///
/// [showContextMenu] is a function that when called shows the context menu
/// for the travel widget.
typedef TravelWidgetGestureOverride = void Function(
  Offset globalPosition,
  TravelWidgetShowContextMenu showContextMenu,
);

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelWidgetGestureWrapper extends StatefulWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The travel item to wrap.
  final TravelItemEntity travelItem;

  /// The function to call when the widget is tapped.
  ///
  /// - If `none`, the default behavior is to show the context menu.
  /// - If `null`, there won't be any action on tap.
  /// - Otherwise it will be called with the global position of the tap and
  ///  the function to show the context menu.
  final Option<TravelWidgetGestureOverride?> onTapOverride;

  /// The function to call when the widget is long pressed.
  ///
  /// - If `none`, the default behavior is to show the context menu.
  /// - If `null`, there won't be any action on long press.
  /// - Otherwise it will be called with the global position of the long press
  /// and the function to show the context menu.
  final Option<TravelWidgetGestureOverride?> onLongPressOverride;

  /// The child widget to wrap.
  final Widget child;

  /// Creates a travel widget.
  const TravelWidgetGestureWrapper({
    required this.index,
    required this.travelItem,
    required this.child,
    this.onTapOverride = const Option.none(),
    this.onLongPressOverride = const Option.none(),
    super.key,
  });

  @override
  State<TravelWidgetGestureWrapper> createState() =>
      _TravelWidgetGestureWrapperState();
}

class _TravelWidgetGestureWrapperState
    extends State<TravelWidgetGestureWrapper> {
  bool _isHovering = false;
  Offset _globalPosition = Offset.zero;

  void _gestureHandler(BuildContext context, [Offset? globalPosition]) {
    setState(() => _isHovering = true);
    TravelItemWidgetContextMenu.showForItem(
      context: context,
      position: globalPosition ?? _globalPosition,
      travelItem: widget.travelItem,
      folderId: widget.travelItem.isWidget
          ? widget.travelItem.asWidget.folderId
          : null,
      index: widget.index,
    ).then((_) => setState(() => _isHovering = false));
  }

  Widget _addGestures(BuildContext context) {
    final bothNull = Option.Do(($) {
      final t = $(widget.onTapOverride);
      final l = $(widget.onLongPressOverride);
      return t == null && l == null;
    });
    if (bothNull.getOrElse(() => false)) {
      return widget.child;
    }
    return InkWell(
      onTapDown: (details) {
        _globalPosition = details.globalPosition;
      },
      onLongPress: widget.onLongPressOverride.match(
        () => () => _gestureHandler(context),
        (f) => f == null ? null : () => f(_globalPosition, _gestureHandler),
      ),
      onTapUp: widget.onTapOverride.match(
        () => (details) => _gestureHandler(context, details.globalPosition),
        (f) => f == null
            ? null
            : (details) => f(details.globalPosition, _gestureHandler),
      ),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: ColoredBox(
              color: _isHovering
                  ? context.col.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
              child: _addGestures(context),
            ),
          ),
        ),
      ],
    );
  }
}
