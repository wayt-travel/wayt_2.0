import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../features.dart';

/// {@template transfer_widget_tile}
/// Tile to display a transfer widget in a travel document.
/// {@endtemplate}
class TransferWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The transfer widget to display.
  final TransferWidgetModel transfer;

  /// {@macro transfer_widget_tile}
  const TransferWidgetTile({
    required this.index,
    required this.transfer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stops = transfer.stops;
    final startingStop = transfer.startingStop;
    final endingStop = transfer.endingStop;

    final subtitle = [
      '${startingStop.name} → ${endingStop.name}',
      if (stops.length > 2) '\n${stops.length - 2} intermediate stops',
    ].join('');

    return TravelWidgetGestureWrapper(
      onTapOverride: Option.of(
        (_, __) {},
      ),
      index: index,
      travelItem: transfer,
      child: Card.outlined(
        margin: EdgeInsets.symmetric(
          vertical: $insets.xxs,
          horizontal: $insets.xs,
        ),
        child: ListTile(
          leading: Icon(
            transfer.meansOfTransport.icon,
            color: context.col.primary,
          ),
          title: Text(
            'Transfer by '
            '${transfer.meansOfTransport.getLocalizedName(context)}',
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
