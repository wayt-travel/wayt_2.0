import 'package:pub_semver/pub_semver.dart';

import '../../widget_feature.dart';

abstract interface class TextWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// The text of the feature.
  String get data;

  /// The format of the text.
  TextFormat get format;

  /// The style of the text.
  ///
  /// Not null when [format] is [TextFormat.material].
  FeatureTextStyle? get textStyle;
}

final class TextWidgetFeatureModel extends WidgetFeatureModel
    implements TextWidgetFeatureEntity {
  @override
  final String data;

  @override
  final TextFormat format;

  @override
  final FeatureTextStyle? textStyle;

  TextWidgetFeatureModel({
    required super.id,
    required this.data,
    required this.format,
    this.textStyle,
    super.index,
  }) : super(
          type: WidgetFeatureType.text,
          version: Version(1, 0, 0),
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
