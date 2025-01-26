import 'dart:math';

import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

/// A class that generates random colors from the material palette.
class RandomColor {
  final Random? _random;
  final int intensity;
  List<MaterialColor>? _colors;
  int _lastPick = -1;

  static final List<MaterialColor> materialColors = List.unmodifiable([
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ]);

  RandomColor._({
    required this.intensity,
    required Random? random,
  })  : _random = random,
        assert(
          Colors.orange[intensity] != null,
          '$intensity is not a valid intensity. It should be 50, 100, 200, '
          '..., or 900.',
        );

  factory RandomColor.randomSequence({int? seed, int intensity = 500}) {
    final random = Random(seed);
    final instance = RandomColor._(intensity: intensity, random: random);
    instance._colors = [...materialColors].shuffled(instance._random);
    return instance;
  }

  factory RandomColor.deterministicSequence({int intensity = 500}) =>
      RandomColor._(intensity: intensity, random: null);

  factory RandomColor.random({int? seed, int intensity = 500}) => RandomColor._(
        intensity: intensity,
        random: Random(seed),
      );

  static Color randomColor({int? seed, int intensity = 500}) =>
      RandomColor.random(seed: seed, intensity: intensity).nextColor();

  static Color colorFromInt(int value, {int intensity = 500}) =>
      materialColors[value % materialColors.length][intensity]!;

  Color nextColor() {
    if (_random == null) {
      return materialColors[++_lastPick % materialColors.length][intensity]!;
    }
    if (_colors?.isNotEmpty ?? false) {
      return _colors![++_lastPick % _colors!.length][intensity]!;
    }
    return materialColors[_lastPick = _random.nextInt(materialColors.length)]
        [intensity]!;
  }

  List<Color> nextColors(int count) {
    final colors = <Color>[];
    for (var i = 0; i < count; i++) {
      colors.add(nextColor());
    }
    return colors;
  }
}
