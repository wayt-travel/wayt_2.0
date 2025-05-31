import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

/// A Widget feature that contains duration information.
abstract interface class DurationWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// {@template duration_widget_feature_duration}
  /// The duration in seconds.
  /// {@endtemplate}
  int get duration;
}

/// Implementation of [DurationWidgetFeatureEntity].
class DurationWidgetFeatureModel extends WidgetFeatureModel
    implements DurationWidgetFeatureEntity {
  @override
  final int duration;

  /// Creates a new [DurationWidgetFeatureModel] instance.
  DurationWidgetFeatureModel({
    required super.id,
    required this.duration,
  }) : super(
          type: WidgetFeatureType.duration,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [DurationWidgetFeatureModel] with the given
  /// parameters.
  DurationWidgetFeatureModel copyWith({
    int? duration,
  }) =>
      DurationWidgetFeatureModel(
        id: id,
        duration: duration ?? this.duration,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        duration,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'duration': duration,
      };
}
