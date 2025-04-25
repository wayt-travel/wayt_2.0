import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';

import '../../../../repositories/repositories.dart';

/// {@template text_widget_tile}
/// A widget that displays a text widget.
///
/// The implementation is very simple, it just displays the text with the
/// provided text style.
/// {@endtemplate}
class TextWidgetTile extends StatelessWidget {
  /// The text widget to display.
  final TextWidgetModel text;

  /// {@macro text_widget_tile}
  const TextWidgetTile(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Correct the padding of the list tile that otherwise it 16px on the left
      // and 24px on the right.
      contentPadding: 16.asPaddingH,
      title: Text(
        text.text,
        style: text.textStyle?.toFlutterTextStyle(context),
      ),
    );
  }
}
