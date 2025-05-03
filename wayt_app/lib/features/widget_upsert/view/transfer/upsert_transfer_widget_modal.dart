import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/upsert_transfer_widget/upsert_transfer_widget_cubit.dart';
import 'pick_means_of_transport_card.dart';

/// {@template upsert_transfer_widget_modal}
/// A modal for adding or editing a transfer widget.
/// {@endtemplate}
class UpsertTransferWidgetModal extends StatelessWidget {
  const UpsertTransferWidgetModal._();

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
  /// {@macro upsert_transfer_widget_modal}
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    required String? folderId,
    TransferWidgetModel? widgetToUpdate,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => UpsertTransferWidgetCubit(
            travelDocumentId: travelDocumentId,
            index: index,
            travelItemRepository: $.repo.travelItem(),
            folderId: folderId,
            widgetToUpdate: widgetToUpdate,
          ),
          child: const UpsertTransferWidgetModal._(),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (Form.maybeOf(context)?.validate() != true) {
      return;
    }
    final cubit = context.read<UpsertTransferWidgetCubit>();
    final result = cubit.validate(context);

    if (!result.isValid) {
      SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: cubit.state.stops.length < 2
            ? 'At least 2 stops are required'
            : 'Please check the input fields',
      );
      return;
    }

    await context.navRoot.pushBlocListenerBarrier<UpsertTransferWidgetCubit,
        UpsertTransferWidgetState>(
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
            title: Text(
              context.read<UpsertTransferWidgetCubit>().isUpdate
                  ? 'Edit transfer widget'
                  : 'Add transfer widget',
            ),
          ),
          body: CustomScrollView(
            slivers: [
              const _FormBody(),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.read<UpsertTransferWidgetCubit>().addStop(
                    const TransferStop(
                      name: 'HAHAHA',
                      dateTime: null,
                      latLng: LatLng(0, 0),
                      address: null,
                    ),
                  );
            },
            icon: const Icon(Icons.add_location_alt),
            label: Text('Add stop'.toUpperCase()),
          ),
          bottomNavigationBar: BottomAppBar(
            child: FilledButton.icon(
              onPressed: () => _submit(context),
              label: Text(
                'Submit'.toUpperCase(),
              ),
              icon: const Icon(Icons.save),
            ),
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
        const PickMeansOfTransportCard(),
        $insets.sm.asVSpan.asSliver,
        SliverPadding(
          padding: $insets.screenH.asPaddingH,
          // FIXME: l10n
          sliver: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stops',
                style: context.tt.titleLarge,
              ),
              $insets.xxs.asVSpan,
              Text(
                'Tap on the button to add a stop. Add at least 2 stops.',
                style: context.tt.labelMedium,
              ),
            ],
          ).asSliver,
        ),
        $insets.sm.asVSpan.asSliver,
        const _TransferStopList(),
      ],
    );
  }
}

class _TransferStopList extends StatefulWidget {
  const _TransferStopList();

  @override
  State<_TransferStopList> createState() => __TransferStopListState();
}

class __TransferStopListState extends State<_TransferStopList> {
  List<TransferStop> _stops = [];

  void _onReorder(int oldIndex, int newIndex) {
    // Copy the list to avoid modifying the original list.
    final items = [..._stops];
    if (oldIndex < newIndex) {
      // ignore: parameter_assignments
      newIndex--;
    }
    // Nothing to do if the indexes are the same.
    if (oldIndex == newIndex) return;

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    _stops = items;
    setState(() {});
    context.read<UpsertTransferWidgetCubit>().setStops(_stops);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpsertTransferWidgetCubit, UpsertTransferWidgetState>(
      listenWhen: (previous, current) => !listEquals(current.stops, _stops),
      listener: (context, state) {
        if (!mounted) return;
        setState(() => _stops = state.stops);
      },
      child: SliverReorderableList(
        onReorder: _onReorder,
        itemCount: _stops.length,
        itemBuilder: (context, index) {
          final stop = _stops[index];
          return Material(
            key: ValueKey(stop),
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: context.col.primary,
              ),
              contentPadding: $insets.sm.asPaddingLeft,
              onTap: () {},
              onLongPress: () {},
              title: Text(stop.name),
              subtitle: Text(
                '${stop.dateTime?.toIso8601String()}',
              ),
              trailing: ReorderableDragStartListener(
                index: index,
                enabled: true,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: $insets.sm,
                    horizontal: $insets.xs,
                  ),
                  child: const Icon(Icons.drag_indicator),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
