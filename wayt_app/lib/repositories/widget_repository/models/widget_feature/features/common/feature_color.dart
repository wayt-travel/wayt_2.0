import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

/// Color property for widget features.
///
/// It mirrors the colors of Material 3 spec.
///
/// It does not include black and white because they behave differently in
/// Flutter, i.e., they're not defined as [MaterialColor].
enum FeatureColor {
  red,
  pink,
  purple,
  deepPurple,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lightGreen,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  brown,
  grey,
  blueGrey;

  /// Factory constructor that creates a [FeatureColor] from its string
  /// name.
  factory FeatureColor.fromName(String name) => values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw ArgumentError.value(name, 'name', 'Invalid name'),
      );

  /// Converts the [FeatureColor] to a Flutter [Color].
  Color toFlutterColor(BuildContext context) => switch (this) {
        red => Colors.red,
        pink => Colors.pink,
        purple => Colors.purple,
        deepPurple => Colors.deepPurple,
        blue => Colors.blue,
        lightBlue => Colors.lightBlue,
        cyan => Colors.cyan,
        teal => Colors.teal,
        green => Colors.green,
        lightGreen => Colors.lightGreen,
        lime => Colors.lime,
        yellow => Colors.yellow,
        amber => Colors.amber,
        orange => Colors.orange,
        deepOrange => Colors.deepOrange,
        brown => Colors.brown,
        grey => Colors.grey,
        blueGrey => Colors.blueGrey,
      }[context.theme.brightness == Brightness.dark ? 400 : 800]!;
}
