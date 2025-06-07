import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../../repositories/widget/models/widget_model.dart';
import '../../../../util/util.dart';
import '../../../features.dart';

/// {@template file_widget_tile}
/// Tile to display a file widget in a travel document.
/// {@endtemplate}
class FileWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The file widget to display.
  final FileWidgetModel file;

  /// {@macro file_widget_tile}
  const FileWidgetTile({
    required this.index,
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TravelWidgetGestureWrapper(
      onTapOverride: Option.of((_, __) async {
        await context.navRoot.pushBarrier();
        if (context.mounted && file.localPath != null) {
          await LinkUtils.maybeOpenFile(
            context: context,
            absolutePath: file.localPath!,
          );
        }
        if (context.mounted) {
          context.navRoot.pop();
        }
      }),
      index: index,
      travelItem: file,
      child: Card.outlined(
        margin: EdgeInsets.symmetric(
          vertical: $insets.xxs,
          horizontal: $insets.xs,
        ),
        child: ListTile(
          leading: Icon(
            Icons.description_rounded,
            color: context.col.primary,
          ),
          title: Text(
            file.name,
            style: context.tt.bodyLarge,
          ),
        ),
      ),
    );
  }
}
