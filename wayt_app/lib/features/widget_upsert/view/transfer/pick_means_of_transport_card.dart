import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';
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
        return FormField<MeansOfTransportType?>(
          key: ValueKey(mot),
          validator:
              UpsertTransferWidgetCubit.getMeansOfTransportValidator(context)
                  .formFieldValidator,
          initialValue: mot,
          builder: (formState) => Card.outlined(
            shape: RoundedRectangleBorder(
              borderRadius: $corners.card.asBorderRadius,
              side: BorderSide(
                color: formState.hasError
                    ? context.col.error
                    : context.col.primary,
                width: formState.hasError ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              onTap: () => MeansOfTransportPicker.show(context).then((newMot) {
                if (newMot != null && context.mounted) {
                  context
                      .read<UpsertTransferWidgetCubit>()
                      .updateMeansOfTransport(newMot);
                }
              }),
              leading: Icon(
                mot == null
                    ? (formState.hasError
                        ? Icons.priority_high
                        : Icons.question_mark)
                    : mot.icon,
                color: formState.hasError
                    ? context.col.error
                    : context.col.primary,
              ),
              title: Text(
                // FIXME: l10n
                'Means of transport',
                style: context.tt.bodyLarge,
              ),
              subtitle: Text(
                // FIXME: l10n
                mot == null
                    ? 'Select a means of transport'
                    : mot.getLocalizedName(context),
                style: TextStyle(
                  color: formState.hasError
                      ? context.col.error
                      : context.col.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: context.col.primary,
              ),
            ),
          ),
        ).asSliver;
      },
    );
  }
}
