import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/core.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../../theme/theme.dart';
import '../../../../../util/util.dart';
import '../../../../../widgets/widgets.dart';
import '../../../../features.dart';
import '../../../bloc/upsert_transfer_stop/upsert_transfer_stop_cubit.dart';
import '../../place/picker/lat_lng_picker.dart';

/// {@template upsert_transfer_stop_modal}
/// A modal for adding or editing a transfer stop.
/// {@endtemplate}
class UpsertTransferStopModal extends StatefulWidget {
  const UpsertTransferStopModal._();

  /// Pushes the modal to the navigator.
  ///
  /// [stopToUpdate] is the stop to update. If null, a new stop will be created.
  ///
  /// [suggestedInitialDateTime] is the initial date time to suggest to the user
  /// when launching the picker for the date time. It should be a date time that
  /// makes sense in the travel document (e.g., after the starting date of the
  /// travel) or a date time after another transfer stop in the same transfer
  /// widget.
  ///
  /// {@macro upsert_transfer_stop_modal}
  static Future<TransferStop?> show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required DateTime suggestedInitialDateTime,
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
              travelDocumentRepository: $.repo.travelDocument(),
              suggestedInitialDateTime: suggestedInitialDateTime,
            ),
            child: const UpsertTransferStopModal._(),
          ),
        ),
      );

  @override
  State<UpsertTransferStopModal> createState() =>
      _UpsertTransferStopModalState();
}

class _UpsertTransferStopModalState extends State<UpsertTransferStopModal> {
  var _formKey = UniqueKey();

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
        message: validationResult.asError.firstError ??
            'Please check the input fields',
      );
      return;
    }

    final stop = await cubit.submit();
    if (stop != null && context.mounted) {
      // Pop the modal and return the stop
      context.navRoot.pop(stop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                sliver: _FormBody(
                  onForceRebuildForm: () {
                    // Force rebuild the form when the geo feature is selected
                    setState(() => _formKey = UniqueKey());
                  },
                ),
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

class _FormBody extends StatefulWidget {
  final void Function() onForceRebuildForm;
  const _FormBody({required this.onForceRebuildForm});

  @override
  State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  var _latKey = UniqueKey();
  var _lngKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        const Text(
          // FIXME: l10n
          'Select a Time and a Location for the transfer stop',
        ).asSliver,
        $insets.sm.asVSpan.asSliver,
        BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState,
            DateTime?>(
          selector: (state) => state.dateTime,
          builder: (context, currentDateTime) {
            return Column(
              children: [
                OneActionCard<DateTime?>(
                  initialValue: currentDateTime,
                  leadingIcon: Icons.schedule,
                  // FIXME: l10n
                  title: 'Date & Time',
                  subtitle: currentDateTime != null
                      ? DateFormat.yMMMEd().format(currentDateTime) +
                          ' ${DateFormat.Hm().format(currentDateTime)}'
                      // FIXME: l10n
                      : 'Select a date and time',
                  onTap: () => DateTimePicker.show(
                    context,
                    initialDate: currentDateTime ??
                        context
                            .read<UpsertTransferStopCubit>()
                            .suggestedInitialDateTime,
                  ).then((dateTime) {
                    if (dateTime != null && context.mounted) {
                      context
                          .read<UpsertTransferStopCubit>()
                          .updateDateTime(dateTime);
                    }
                  }),
                ),
                if (currentDateTime != null)
                  TextButton(
                    onPressed: () {
                      context
                          .read<UpsertTransferStopCubit>()
                          .updateDateTime(null);
                      widget.onForceRebuildForm();
                    },
                    child: const Text(
                      // FIXME: l10n
                      'Remove date and time',
                    ),
                  )
                else
                  $insets.md.asVSpan,
              ],
            );
          },
        ).asSliver,
        Text(
          // FIXME: l10n
          'Location',
          style: context.tt.titleLarge,
        ).asSliver,
        $insets.sm.asVSpan.asSliver,
        GeoFeaturePickerCard(
          onSelected: (geoFeature) {
            context
                .read<UpsertTransferStopCubit>()
                .updateFromGeoFeature(geoFeature);
            context.unfocus();
            widget.onForceRebuildForm();
          },
        ).asSliver,
        const AltHorizontalLine().asSliver,
        Text(
          'Enter location manually',
          style: context.tt.titleMedium,
        ).asSliver,
        $insets.sm.asVSpan.asSliver,
        BlocSelector<UpsertTransferStopCubit, UpsertTransferStopState, String>(
          selector: (state) => state.name,
          builder: (context, name) {
            return TextFormField(
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
        $insets.sm.asVSpan.asSliver,
        Text(
          // FIXME: l10n
          'Coordinates',
          style: context.tt.titleMedium,
        ).asSliver,
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
            return const SizedBox().asSliver;
          },
        ),
        Center(
          child: TextButton(
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => LatLngPicker.showForTravelDocument(
              context: context,
              travelDocumentId:
                  context.read<UpsertTransferStopCubit>().travelDocumentId,
            ).then((latLng) {
              if (latLng != null && context.mounted) {
                context
                    .read<UpsertTransferStopCubit>()
                    .updateLatLng(latLng.copyWithPrecision(8));
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    // Reset the keys to force the TextFormFields to rebuild
                    // with the new values.
                    _latKey = UniqueKey();
                    _lngKey = UniqueKey();
                  });
                });
              }
            }),
            child: const Text('Select from the map'),
          ),
        ).asSliver,
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
            key: isLat ? _latKey : _lngKey,
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
