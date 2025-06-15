import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template font_weight_json_converter}
/// A JSON converter for [FontWeight] objects.
///
/// This converter serializes [FontWeight] objects to a JSON map and vice versa.
/// {@endtemplate}
class FontWeightJsonConverter
    extends JsonConverter<FontWeight, Map<String, dynamic>> {
  /// {@macro font_weight_json_converter}
  const FontWeightJsonConverter();

  @override
  FontWeight fromJson(Map<String, dynamic> json) => FontWeight.values
      .firstWhere((weight) => weight.value == json['thickness'] as int);

  @override
  Map<String, dynamic> toJson(FontWeight object) => {'thickness': object.value};
}
