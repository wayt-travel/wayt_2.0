import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

/// A widget feature that represents a means of transport.
abstract interface class MeansOfTransportWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// The type of the means of transport.
  MeansOfTransportType get motType;
}

/// Implementation of [MeansOfTransportWidgetFeatureEntity].
class MeansOfTransportWidgetFeatureModel extends WidgetFeatureModel
    implements MeansOfTransportWidgetFeatureEntity {
  @override
  final MeansOfTransportType motType;

  /// Creates a new [MeansOfTransportWidgetFeatureModel] instance.
  MeansOfTransportWidgetFeatureModel({
    required super.id,
    required this.motType,
  }) : super(
          type: WidgetFeatureType.meansOfTransport,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [MeansOfTransportWidgetFeatureModel] with the given
  /// parameters.

  MeansOfTransportWidgetFeatureModel copyWith({
    MeansOfTransportType? motType,
  }) =>
      MeansOfTransportWidgetFeatureModel(
        id: id,
        motType: motType ?? this.motType,
      );
}
