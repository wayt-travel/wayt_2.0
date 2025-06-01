import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

/// A Widget feature that contains duration information.
abstract interface class DurationWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// {@template duration_widget_feature_data}
  /// The duration in seconds.
  /// {@endtemplate}
  Duration get data;
}

/// Implementation of [DurationWidgetFeatureEntity].
class DurationWidgetFeatureModel extends WidgetFeatureModel
    implements DurationWidgetFeatureEntity {
  @override
  final Duration data;

  /// Creates a new [DurationWidgetFeatureModel] instance.
  DurationWidgetFeatureModel({
    required super.id,
    required this.data,
  }) : super(
          type: WidgetFeatureType.duration,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [DurationWidgetFeatureModel] with the given
  /// parameters.
  DurationWidgetFeatureModel copyWith({
    Duration? data,
  }) =>
      DurationWidgetFeatureModel(
        id: id,
        data: data ?? this.data,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        data,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'data': data,
      };
}
