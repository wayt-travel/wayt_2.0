import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../theme/theme.dart';
import '../../../../util/util.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/upsert_transfer_stop/upsert_transfer_stop_cubit.dart';

/// {@template upsert_transfer_stop_modal}
/// A modal for adding or editing a transfer stop.
/// {@endtemplate}
class UpsertTransferStopModal extends StatelessWidget {
  const UpsertTransferStopModal._();

  /// Pushes the modal to the navigator.
  ///
  /// [stopToUpdate] is the stop to update. If null, a new stop will be created.
  ///
  /// {@macro upsert_transfer_stop_modal}
  static Future<TransferStop?> show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    TransferStop? stopToUpdate,
  }) =>
      context.navRoot.push<TransferStop>(
        MaterialPageRoute<TransferStop>(
          fullscreenDialog: true,
          builder: (context) => BlocProvider(
            create: (context) => UpsertTransferStopCubit(
              travelDocumentId: travelDocumentId,
              stopToUpdate: stopToUpdate,
              travelItemRepository: $.repo.travelItem(),
            ),
            child: const UpsertTransferStopModal._(),
          ),
        ),
      );

  Future<void> _submit(BuildContext context) async {
    if (Form.maybeOf(context)?.validate() != true) {
      return;
    }

    final cubit = context.read<UpsertTransferStopCubit>();
    final validationResult = cubit.validate(context);

    if (!validationResult.isValid) {
      SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: 'Please check the input fields',
      );
      return;
    }

    final stop = await cubit.submit();
    if (stop != null && context.mounted) {
      context.navRoot.pop(stop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            // FIXME: l10n
            title: Text(
              context.read<UpsertTransferStopCubit>().isUpdate
                  ? 'Edit Transfer Stop'
                  : 'Add Transfer Stop',
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: $insets.screenH.asPaddingH,
                sliver: const _FormBody(),
              ),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _submit(context),
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState, String>(
          selector: (state) => state.name,
          builder: (context, name) {
            return TextFormField(
              autofocus: true,
              initialValue: name,
              validator: context
                  .read<UpsertTransferStopCubit>()
                  .getNameValidator(context)
                  .formFieldValidator,
              onChanged: (value) =>
                  context.read<UpsertTransferStopCubit>().updateName(value),
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Name',
              ),
            ).asSliver;
          },
        ),
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState, String?>(
          selector: (state) => state.address,
          builder: (context, address) {
            return TextFormField(
              initialValue: address,
              onChanged: (value) =>
                  context.read<UpsertTransferStopCubit>().updateAddress(value),
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Address',
              ),
              validator: context
                  .read<UpsertTransferStopCubit>()
                  .getAddressValidator(context)
                  .formFieldValidator,
              maxLines: 3,
            ).asSliver;
          },
        ),
        $insets.xs.asVSpan.asSliver,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLatOrLngTextFormField(context, isLat: true),
            $insets.xs.asHSpan,
            _buildLatOrLngTextFormField(context, isLat: false),
          ],
        ).asSliver,
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState,
            DateTime?>(
          selector: (state) => state.dateTime,
          builder: (context, dateTime) {
            return DateTimePicker(
              initialDateTime: dateTime,
              onChanged: (value) =>
                  context.read<UpsertTransferStopCubit>().updateDateTime(value),
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Date & Time',
              ),
            ).asSliver;
          },
        ),
      ],
    );
  }

  Widget _buildLatOrLngTextFormField(
    BuildContext context, {
    required bool isLat,
  }) {
    return Expanded(
      child: BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState,
          double?>(
        selector: (state) => isLat ? state.lat : state.lng,
        builder: (context, value) {
          final cubit = context.read<UpsertTransferStopCubit>();
          return TextFormField(
            initialValue: value?.toString(),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: <TextInputFormatter>[
              ReplaceCommaFormatter('.'),
              FilteringTextInputFormatter.allow(
                RegExp(r'^-?((0|([1-9][0-9]*))([\.,][0-9]*)?)?'),
              ),
            ],
            validator: (value) => isLat
                ? cubit
                    .getLatValidator(context)
                    .formFieldValidator(double.tryParse(value ?? ''))
                : cubit
                    .getLngValidator(context)
                    .formFieldValidator(double.tryParse(value ?? '')),
            onChanged: (value) {
              final doubleValue = double.tryParse(value);
              isLat
                  ? cubit.updateLat(doubleValue)
                  : cubit.updateLng(doubleValue);
            },
            decoration: InputDecoration(
              // FIXME: l10n
              labelText: isLat ? 'Latitude' : 'Longitude',
            ),
          );
        },
      ),
    );
  }
}
