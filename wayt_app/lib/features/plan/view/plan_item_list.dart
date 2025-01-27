import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../../folder_display/bloc/folder/folder_cubit.dart';
import '../../folder_display/view/folder_widget.dart';
import '../../widget_display/widget_display.dart';
import '../bloc/reorder_items/reorder_items_cubit.dart';

/// A widget displaying the list of travel items of a plan.
///
/// It can be used to display the items in the root of a travel plan or the
/// items within a folder.
///
/// NB: This widget should have a bloc provider ancestor that provides its
/// subtree with a [ReorderItemsCubit].
class PlanItemList extends StatefulWidget {
  /// The map of travel items.
  ///
  /// The map is expected to be ordered by the items order.
  final Map<String, TravelItemEntityWrapper> travelItemsMap;

  /// The ID of the folder.
  ///
  /// If `null`, the items [travelItemsMap] are those at the root of the travel
  /// document.
  final String? folderId;

  /// The ID of the travel document.
  final TravelDocumentId travelDocumentId;

  /// Creates a new instance of [PlanItemList].
  PlanItemList({
    required this.travelDocumentId,
    required this.folderId,
    required List<TravelItemEntityWrapper> travelItems,
    super.key,
  }) : travelItemsMap = Map.fromEntries(
          travelItems.map((e) => MapEntry(e.value.id, e)),
        );

  @override
  State<PlanItemList> createState() => _PlanItemListState();
}

class _PlanItemListState extends State<PlanItemList> {
  late List<String> _reorderedItemIds;
  var _isReordering = false;

  @override
  void initState() {
    super.initState();
    _reorderedItemIds = widget.travelItemsMap.keys.toList();
    _isReordering = context.read<ReorderItemsCubit>().isReordering;
  }

  /// Builds a tile for a travel item.
  Widget _buildTile(BuildContext context, TravelItemEntity item) {
    if (item is TextWidgetModel) {
      return ListTile(
        title: Text(
          item.textFeature.data,
          style: item.textFeature.textStyle?.toFlutterTextStyle(context),
        ),
      );
    }
    // TODO: Implement other widget types
    return ListTile(
      title: Text('Item ${item.asWidget.type} is not supported yet'),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    // Copy the list to avoid modifying the original list.
    final items = [..._reorderedItemIds];
    if (oldIndex < newIndex) {
      // ignore: parameter_assignments
      newIndex--;
    }
    // Nothing to do if the indexes are the same.
    if (oldIndex == newIndex) return;

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    _reorderedItemIds = items;
    setState(() {});
    final bloc = context.read<ReorderItemsCubit>();
    context.navRoot
        .pushBlocListenerBarrier<ReorderItemsCubit, ReorderItemsState>(
      bloc: bloc,
      trigger: () => bloc.save(_reorderedItemIds),
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          context.pop();
        } else if (state.status == StateStatus.failure) {
          context.pop();
          SnackBarHelper.I.showError(
            context: context,
            message: state.error!.userIntlMessage(context),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReorderItemsCubit, ReorderItemsState>(
      listenWhen: (previous, current) =>
          current.isReordering != previous.isReordering,
      listener: (context, state) {
        if (!mounted) return;
        setState(() {
          _isReordering = state.isReordering;
        });
      },
      child: SliverReorderableList(
        onReorder: _onReorder,
        itemCount: _reorderedItemIds.length,
        itemBuilder: (context, index) {
          final wrapper = widget.travelItemsMap[_reorderedItemIds[index]]!;
          late final Widget child;
          if (wrapper.value.isFolderWidget) {
            child = BlocProvider(
              create: (context) => FolderCubit(
                folderId: wrapper.value.id,
                travelItemRepository: $.repo.travelItem(),
              ),
              child: FolderWidget(index: index),
            );
          } else {
            child = TravelWidget(
              index: index,
              travelItem: wrapper.value,
              child: _buildTile(context, wrapper.value),
            );
          }
          return Material(
            key: ValueKey(wrapper.value.id),
            child: Row(
              children: [
                Expanded(child: child),
                if (_isReordering)
                  ReorderableDragStartListener(
                    index: index,
                    enabled: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: $insets.sm,
                        horizontal: $insets.x3s,
                      ),
                      child: const Icon(Icons.drag_indicator),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
