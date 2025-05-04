import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../theme/theme.dart';
import '../../../../util/util.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';
import '../../bloc/upsert_transfer_widget/upsert_transfer_widget_cubit.dart';

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
            travelDocumentRepository: $.repo.travelDocument(),
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
        message: result.asError.firstError ?? 'Please check the input fields',
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
              final cubit = context.read<UpsertTransferWidgetCubit>();
              UpsertTransferStopModal.show(
                context: context,
                travelDocumentId: cubit.travelDocumentId,
                suggestedInitialDateTime: cubit.suggestedInitialDateTime,
              ).then((stop) {
                if (stop != null && context.mounted) {
                  context.read<UpsertTransferWidgetCubit>().addStop(stop);
                }
              });
            },
            icon: const Icon(Icons.add_location_alt),
            // FIXME: l10n
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
        SliverPadding(
          padding: $insets.screenH.asPaddingH,
          sliver: const PickMeansOfTransportCard().asSliver,
        ),
        $insets.sm.asVSpan.asSliver,
        SliverPadding(
          padding: $insets.screenH.asPaddingH,
          // FIXME: l10n
          sliver: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // FIXME: l10n
                'Stops',
                style: context.tt.titleLarge,
              ),
              $insets.xxs.asVSpan,
              Text(
                // FIXME: l10n
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
              title: Text(
                stop.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                stop.dateTime == null
                    // FIXME: l10n
                    ? 'No date'
                    : DateFormat.yMEd().format(stop.dateTime!) +
                        ' ${DateFormat.Hm().format(stop.dateTime!)}',
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
