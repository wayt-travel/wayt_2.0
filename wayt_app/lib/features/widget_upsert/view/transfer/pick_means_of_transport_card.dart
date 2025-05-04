import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';
import '../../bloc/upsert_transfer_widget/upsert_transfer_widget_cubit.dart';

/// {@template pick_means_of_transport_card}
/// A card that allows the user to pick a means of transport.
///
/// This card is used in the [UpsertTransferWidgetModal] to select a means of
/// transport.
/// {@endtemplate}
class PickMeansOfTransportCard extends StatelessWidget {
  /// {@macro pick_means_of_transport_card}
  const PickMeansOfTransportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UpsertTransferWidgetCubit, UpsertTransferWidgetState,
        MeansOfTransportType?>(
      selector: (state) => state.meansOfTransport,
      builder: (context, mot) {
        return OneActionCard<MeansOfTransportType?>(
          validator:
              UpsertTransferWidgetCubit.getMeansOfTransportValidator(context)
                  .formFieldValidator,
          initialValue: mot,
          onTap: () => MeansOfTransportPicker.show(context).then((newMot) {
            if (newMot != null && context.mounted) {
              context
                  .read<UpsertTransferWidgetCubit>()
                  .updateMeansOfTransport(newMot);
            }
          }),
          leadingIcon: mot?.icon ?? Icons.question_mark,
          // FIXME: l10n
          title: 'Means of transport',
          subtitle: mot == null
              // FIXME: l10n
              ? 'Select a means of transport'
              : mot.getLocalizedName(context),
        );
      },
    );
  }
}
