import 'dart:io';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';

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
  /// The photo widget to display.
  final PhotoWidgetModel photo;

  /// {@macro photo_widget_tile}
  const PhotoWidgetTile(this.photo, {super.key});

  @override
  Widget build(BuildContext context) {
    final fileWidget = Padding(
      padding: $insets.xs.asPaddingV,
      child: Image.file(
        File(photo.localPath!),
        key: ValueKey(photo.localPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
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
