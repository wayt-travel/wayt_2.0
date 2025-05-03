import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../repositories/repositories.dart';
import '../../../features.dart';

/// {@template place_widget_tile}
/// Tile to display a place widget in a travel document.
/// {@endtemplate}
class PlaceWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The place widget to display.
  final PlaceWidgetModel place;

  /// {@macro place_widget_tile}
  const PlaceWidgetTile({
    required this.index,
    required this.place,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var subtitle = place.latLng.toPrettyString();
    if (place.address != null) {
      subtitle = '$subtitle — ${place.address}';
    }
    return TravelWidgetGestureWrapper(
      onTapOverride: Option.of(
        (_, __) {},
      ),
      index: index,
      travelItem: place,
      child: Card.outlined(
        child: ListTile(
          leading: Icon(
            Icons.place,
            color: context.col.primary,
          ),
          title: Text(
            place.name,
            style: context.tt.bodyLarge,
          ),
          subtitle: Text(
            subtitle,
            style: context.tt.labelSmall,
          ),
        ),
      ),
    );
  }
}
