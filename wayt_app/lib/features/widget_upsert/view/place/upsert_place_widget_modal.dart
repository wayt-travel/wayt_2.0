import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../theme/theme.dart';
import '../../../../util/util.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/upsert_place_widget/upsert_place_widget_cubit.dart';
import 'picker/lat_lng_picker.dart';

/// {@template upsert_place_widget_modal}
/// A modal for adding or editing a place widget.
/// {@endtemplate}
class UpsertPlaceWidgetModal extends StatelessWidget {
  const UpsertPlaceWidgetModal._();

  /// Pushes the modal to the navigator.
  ///
  /// [index] is the index where the widget will be added in the travel
  /// document root or in the folder. If the widget is being edited, this value
  /// is ignored.
  ///
  /// [widgetToUpdate] is the widget to update. If null, a new widget will be
  /// created.
  ///
  /// [folderId] is the id of the folder where the widget will be added.
  /// If null, the widget will be added at the root of the travel document.
  /// If the widget is being edited, this value is ignored.
  ///
  /// {@macro upsert_place_widget_modal}
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    required String? folderId,
    PlaceWidgetModel? widgetToUpdate,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => UpsertPlaceWidgetCubit(
            travelDocumentId: travelDocumentId,
            index: index,
            travelItemRepository: $.repo.travelItem(),
            folderId: folderId,
            widgetToUpdate: widgetToUpdate,
          ),
          child: const UpsertPlaceWidgetModal._(),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (Form.maybeOf(context)?.validate() != true) {
      return;
    }
    final cubit = context.read<UpsertPlaceWidgetCubit>();
    final result = cubit.validate(context);

    if (!result.isValid) {
      SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: result.asError.firstError ?? 'Please check the input fields',
      );
      return;
    }

    await context.navRoot.pushBlocListenerBarrier<UpsertPlaceWidgetCubit,
        UpsertPlaceWidgetState>(
      bloc: cubit,
      trigger: cubit.submit,
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          context.navRoot
            ..pop()
            ..pop();
        } else if (state.status == StateStatus.failure) {
          SnackBarHelper.I.showError(
            context: context,
            message: state.error!.userIntlMessage(context),
          );
          context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            // FIXME: l10n
            title: const Text('Add place widget'),
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

class _FormBody extends StatefulWidget {
  const _FormBody();

  @override
  State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  var _latKey = UniqueKey();
  var _lngKey = UniqueKey();

  Widget _buildLatOrLngTextFormField(
    BuildContext context, {
    required bool isLat,
  }) {
    return Expanded(
      child:
          BlocSelector<UpsertPlaceWidgetCubit, UpsertPlaceWidgetState, double?>(
        selector: (state) => isLat ? state.lat : state.lng,
        builder: (context, value) {
          final cubit = context.read<UpsertPlaceWidgetCubit>();
          return TextFormField(
            key: isLat ? _latKey : _lngKey,
            initialValue: value?.toString(),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: <TextInputFormatter>[
              ReplaceCommaFormatter('.'),
              DoubleTextInputFormatter(),
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

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertPlaceWidgetCubit, UpsertPlaceWidgetState, String?>(
          selector: (state) => state.name,
          builder: (context, name) {
            return TextFormField(
              autofocus: true,
              initialValue: name,
              validator: context
                  .read<UpsertPlaceWidgetCubit>()
                  .getNameValidator(context)
                  .formFieldValidator,
              onChanged: (value) =>
                  context.read<UpsertPlaceWidgetCubit>().updateName(value),
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Name',
              ),
            ).asSliver;
          },
        ),
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertPlaceWidgetCubit, UpsertPlaceWidgetState, String?>(
          selector: (state) => state.address,
          builder: (context, address) {
            return TextFormField(
              initialValue: address,
              onChanged: (value) =>
                  context.read<UpsertPlaceWidgetCubit>().updateAddress(value),
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Address',
              ),
              validator: context
                  .read<UpsertPlaceWidgetCubit>()
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
        Center(
          child: TextButton(
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => LatLngPicker.showForTravelDocument(
              context: context,
              travelDocumentId:
                  context.read<UpsertPlaceWidgetCubit>().travelDocumentId,
            ).then((latLng) {
              if (latLng != null && context.mounted) {
                context
                    .read<UpsertPlaceWidgetCubit>()
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
}
