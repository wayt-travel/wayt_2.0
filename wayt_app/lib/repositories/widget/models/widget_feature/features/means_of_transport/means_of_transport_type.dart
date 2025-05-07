import 'package:flutter/material.dart';

/// Type of means of transport.
enum MeansOfTransportType {
  /// The means of transport is a car.
  car,

  /// The means of transport is a bus.
  bus,

  /// The means of transport is a train.
  train,

  /// The means of transport is a bicycle.
  bicycle,

  /// The means of transport is a motorcycle.
  motorcycle,

  /// The means of transport is a plane.
  plane,

  /// The means of transport is a boat.
  boat,

  /// The means of transport is a tram.
  tram,

  /// The means of transport is a subway.
  subway,

  /// The means of transport is a ferry.
  ferry,

  /// The means of transport is a taxi.
  taxi,

  /// The means of transport is a walk.
  walk,

  /// The means of transport is a helicopter.
  helicopter,

  /// The means of transport is a hot air balloon.
  hotAirBalloon;

  /// Gets the icon associated with the means of transport type.
  IconData get icon => switch (this) {
        MeansOfTransportType.car => Icons.directions_car,
        MeansOfTransportType.bus => Icons.directions_bus,
        MeansOfTransportType.train => Icons.directions_railway,
        MeansOfTransportType.bicycle => Icons.directions_bike,
        MeansOfTransportType.motorcycle => Icons.motorcycle,
        MeansOfTransportType.plane => Icons.airplanemode_active,
        MeansOfTransportType.boat => Icons.sailing,
        MeansOfTransportType.tram => Icons.tram,
        MeansOfTransportType.subway => Icons.subway,
        MeansOfTransportType.ferry => Icons.directions_boat,
        MeansOfTransportType.taxi => Icons.local_taxi,
        MeansOfTransportType.walk => Icons.directions_walk,
        MeansOfTransportType.helicopter => Icons.rocket,
        MeansOfTransportType.hotAirBalloon => Icons.paragliding,
      };

  /// Gets the name of the means of transport type.
  String getLocalizedName(BuildContext context) => switch (this) {
        // FIXME: l10n
        MeansOfTransportType.car => 'Car',
        // FIXME: l10n
        MeansOfTransportType.bus => 'Bus',
        // FIXME: l10n
        MeansOfTransportType.train => 'Train',
        // FIXME: l10n
        MeansOfTransportType.bicycle => 'Bicycle',
        // FIXME: l10n
        MeansOfTransportType.motorcycle => 'Motorcycle',
        // FIXME: l10n
        MeansOfTransportType.plane => 'Plane',
        // FIXME: l10n
        MeansOfTransportType.boat => 'Boat',
        // FIXME: l10n
        MeansOfTransportType.tram => 'Tram',
        // FIXME: l10n
        MeansOfTransportType.subway => 'Subway',
        // FIXME: l10n
        MeansOfTransportType.ferry => 'Ferry',
        // FIXME: l10n
        MeansOfTransportType.taxi => 'Taxi',
        // FIXME: l10n
        MeansOfTransportType.walk => 'Walk',
        // FIXME: l10n
        MeansOfTransportType.helicopter => 'Helicopter',
        // FIXME: l10n
        MeansOfTransportType.hotAirBalloon => 'Hot Air Balloon',
      };
}
