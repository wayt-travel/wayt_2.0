import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

part 'typography_widget_feature.gen.g.dart';

/// The entity of a typography feature.
abstract interface class TypographyWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// The text of the feature.
  String get data;

  /// The format of the text.
  TypographyFormat get format;

  /// The style of the text.
  ///
  /// Not null when [format] is [TypographyFormat.material].
  TypographyFeatureStyle? get textStyle;
}

/// The model of a typography feature.
@JsonSerializable(constructor: '_')
@VersionJsonConverter()
final class TypographyWidgetFeatureModel extends WidgetFeatureModel
    implements TypographyWidgetFeatureEntity {
  @override
  final String data;

  @override
  final TypographyFormat format;

  @override
  final TypographyFeatureStyle? textStyle;

  /// Creates a new [TypographyWidgetFeatureModel] instance.
  TypographyWidgetFeatureModel({
    required String id,
    required String data,
    required TypographyFormat format,
    TypographyFeatureStyle? textStyle,
    Version? version,
  }) : this._(
          id: id,
          data: data,
          format: format,
          textStyle: textStyle,
          type: WidgetFeatureType.typography,
          version: version ?? Version(1, 0, 0),
        );

  /// Private constructor used for json serialization.
  TypographyWidgetFeatureModel._({
    required super.id,
    required this.data,
    required this.format,
    required this.textStyle,
    required super.type,
    required super.version,
  });

  /// Creates a [TypographyWidgetFeatureModel] from a JSON map.
  factory TypographyWidgetFeatureModel.fromJson(Json json) =>
      _$TypographyWidgetFeatureModelFromJson(json);

  /// Converts this model to a JSON map.
  @override
  Json toJson() => _$TypographyWidgetFeatureModelToJson(this);

  /// Creates a new [TypographyWidgetFeatureModel] instance from the given
  /// parameters.
  TypographyWidgetFeatureModel copyWith({
    String? data,
    TypographyFormat? format,
    TypographyFeatureStyle? textStyle,
  }) =>
      TypographyWidgetFeatureModel._(
        id: id,
        data: data ?? this.data,
        format: format ?? this.format,
        textStyle: textStyle ?? this.textStyle,
        type: type,
        version: version,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        data,
        format,
        textStyle,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'format': format.toString(),
        'data': data,
        'textStyle': textStyle?.toString(),
      };
}
