import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:uuid/uuid.dart';

import '../../../../repositories.dart';

/// {@template transfer_stop}
/// A model representing a stop in a transfer widget.
/// {@endtemplate}
class TransferStop extends Model {
  /// The name of the stop.
  final String name;

  /// The address of the stop.
  final String? address;

  /// The coordinates of the stop.
  final LatLng latLng;

  /// The timestamp of the stop.
  ///
  /// It is the time when the stop is reached.
  final DateTime? dateTime;

  /// {@macro transfer_stop}
  const TransferStop({
    required this.name,
    required this.address,
    required this.latLng,
    required this.dateTime,
  });

  /// Creates a new [TransferStop] instance from a [GeoWidgetFeatureEntity].
  factory TransferStop.fromGeoWidgetFeature(
    GeoWidgetFeatureEntity geoFeature,
  ) =>
      TransferStop(
        name: geoFeature.name ?? 'n/a',
        address: geoFeature.address,
        latLng: geoFeature.latLng,
        dateTime: geoFeature.timestamp,
      );

  /// Turns this [TransferStop] into a [GeoWidgetFeatureEntity].
  GeoWidgetFeatureEntity toGeoWidgetFeature({String? id}) =>
      GeoWidgetFeatureModel(
        id: id ?? const Uuid().v4(),
        latLng: latLng,
        name: name,
        address: address,
        timestamp: dateTime,
      );

  @override
  List<Object?> get props => [
        name,
        address,
        latLng,
        dateTime,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        'name': name,
        'address': address,
        'latLng': latLng.toString(),
        'dateTime': dateTime?.toIso8601String(),
      };
}
