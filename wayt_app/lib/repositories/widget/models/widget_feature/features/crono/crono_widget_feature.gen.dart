import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

part 'crono_widget_feature.gen.g.dart';

/// {@template duration_widget_feature_entity}
/// A Widget feature that contains information about time.
/// {@endtemplate}
abstract interface class CronoWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// {@template duration_widget_feature_data}
  /// The duration.
  /// {@endtemplate}
  Duration? get duration;

  /// {@template duration_widget_feature_starting_at}
  /// The starting time of the crono widget feature.
  /// {@endtemplate}
  DateTime? get startingAt;

  /// {@template duration_widget_feature_ending_at}
  /// The ending time of the crono widget feature.
  /// {@endtemplate}
  DateTime? get endingAt;
}

/// Implementation of [CronoWidgetFeatureEntity].
///
/// {@macro duration_widget_feature_entity}
@JsonSerializable(constructor: '_')
@VersionJsonConverter()
class CronoWidgetFeatureModel extends WidgetFeatureModel
    implements CronoWidgetFeatureEntity {
  @override
  final Duration? duration;

  @override
  final DateTime? startingAt;

  @override
  final DateTime? endingAt;

  /// Creates a new [CronoWidgetFeatureModel] instance.
  CronoWidgetFeatureModel({
    required String id,
    Duration? duration,
    DateTime? startingAt,
    DateTime? endingAt,
    Version? version,
  }) : this._(
          id: id,
          duration: duration,
          startingAt: startingAt,
          endingAt: endingAt,
          version: version ?? Version(1, 0, 0),
          type: WidgetFeatureType.crono,
        );

  /// Private constructor used for json serialization.
  CronoWidgetFeatureModel._({
    required super.id,
    required this.duration,
    required this.startingAt,
    required this.endingAt,
    required super.version,
    required super.type,
  });

  /// Creates a new [CronoWidgetFeatureModel] from a JSON map.
  factory CronoWidgetFeatureModel.fromJson(Json json) =>
      _$CronoWidgetFeatureModelFromJson(json);

  /// Converts this [CronoWidgetFeatureModel] to a JSON map.
  @override
  Json toJson() => _$CronoWidgetFeatureModelToJson(this);

  /// Creates a copy of this [CronoWidgetFeatureModel] with the given
  /// parameters.
  CronoWidgetFeatureModel copyWith({
    Option<Duration?> duration = const Option.none(),
    Option<DateTime?> startingAt = const Option.none(),
    Option<DateTime?> endingAt = const Option.none(),
  }) =>
      CronoWidgetFeatureModel._(
        id: id,
        duration: duration.getOrElse(() => this.duration),
        startingAt: startingAt.getOrElse(() => this.startingAt),
        endingAt: endingAt.getOrElse(() => this.endingAt),
        version: version,
        type: type,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        duration,
        startingAt,
        endingAt,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'duration': duration?.inMilliseconds,
        'startingAt': startingAt?.toIso8601String(),
        'endingAt': endingAt?.toIso8601String(),
      };
}
