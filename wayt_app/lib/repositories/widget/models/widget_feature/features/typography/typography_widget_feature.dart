import 'package:pub_semver/pub_semver.dart';

import '../../widget_feature.dart';

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
    required super.id,
    required this.data,
    required this.format,
    required super.index,
    this.textStyle,
  }) : super(
          type: WidgetFeatureType.text,
          version: Version(1, 0, 0),
        );

  /// Creates a new [TypographyWidgetFeatureModel] instance from the given
  /// parameters.
  TypographyWidgetFeatureModel copyWith({
    String? data,
    TypographyFormat? format,
    TypographyFeatureStyle? textStyle,
  }) =>
      TypographyWidgetFeatureModel(
        id: id,
        index: index,
        data: data ?? this.data,
        format: format ?? this.format,
        textStyle: textStyle ?? this.textStyle,
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
