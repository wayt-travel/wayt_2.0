import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../../widgets/one_action_card.dart';
import '../../../../features.dart';
import '../../../bloc/upsert_transfer_stop/upsert_transfer_stop_cubit.dart';

/// {@template geo_feature_picker_card}
/// A card that allows the user to pick a geo feature from any geo feature
/// available in the travel.
/// {@endtemplate}
class GeoFeaturePickerCard extends StatelessWidget {
  /// The callback to be called when the user selects a geo feature.
  final void Function(GeoWidgetFeatureEntity geoFeature) onSelected;

  /// {@macro geo_feature_picker_card}
  const GeoFeaturePickerCard({
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OneActionCard<void>(
      onTap: () => GeoFeaturePicker.show(
        context,
        travelDocument: context.read<UpsertTransferStopCubit>().let(
              (cubit) =>
                  $.repo.travelDocument().getOrThrow(cubit.travelDocumentId.id),
            ),
      ).then((geoFeature) {
        if (geoFeature != null && context.mounted) {
          onSelected(geoFeature);
        }
      }),
      leadingIcon: Icons.pin_drop,
      title:
          // FIXME: l10n
          'Pick from travel',
      subtitle:
          // FIXME: l10n
          'Select a place from existing widgets in your travel',
      subtitleStyle: const TextStyle(),
    );
  }
}
