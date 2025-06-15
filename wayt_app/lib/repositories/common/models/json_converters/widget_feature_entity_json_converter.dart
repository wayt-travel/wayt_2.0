import 'package:json_annotation/json_annotation.dart';

import '../../../repositories.dart';

/// {@template font_weight_json_converter}
/// A JSON converter for [WidgetFeatureEntity] objects.
///
/// This converter serializes [WidgetFeatureEntity] objects to a JSON map and
/// vice versa.
/// {@endtemplate}
class WidgetFeatureEntityJsonConverter
    extends JsonConverter<WidgetFeatureEntity, Map<String, dynamic>> {
  /// {@macro font_weight_json_converter}
  const WidgetFeatureEntityJsonConverter();

  @override
  WidgetFeatureEntity fromJson(Map<String, dynamic> json) =>
      WidgetFeatureModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(WidgetFeatureEntity object) =>
      (object as WidgetFeatureModel).toJson();
}
