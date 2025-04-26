import 'dart:io';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';

/// {@template photo_widget_tile}
/// A widget that displays a photo widget.
///
/// For the best UX the photo should provide a size. This way while the first
/// frame is loading we can display the widget already with the right size,
/// otherwise the widget will expand to its correct size only after the first
/// frame is loaded causing flickering and jumping while scrolling a list that
/// is built dynamically.
/// {@endtemplate}
class PhotoWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The photo widget to display.
  final PhotoWidgetModel photo;

  /// {@macro photo_widget_tile}
  const PhotoWidgetTile({
    required this.index,
    required this.photo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fileWidget = TravelWidgetGestureWrapper(
      index: index,
      travelItem: photo,
      onLongPressOverride: Option.of(
        (globalPosition, showContextMenu) =>
            showContextMenu(context, globalPosition),
      ),
      onTapOverride: Option.of(
        (_, __) {
          // TODO: Implement photo tap action
          SnackBarHelper.I.showNotImplemented(context);
        },
      ),
      child: Padding(
        padding: $insets.xs.asPaddingV,
        child: Image.file(
          File(photo.localPath!),
          key: ValueKey(photo.localPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
    if (photo.size != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height:
                constraints.maxWidth * (photo.size!.height / photo.size!.width),
            width: constraints.maxWidth,
            child: fileWidget,
          );
        },
      );
    }
    return fileWidget;
  }
}
