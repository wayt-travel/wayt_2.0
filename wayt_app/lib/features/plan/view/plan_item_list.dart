import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../folder_display/bloc/folder/folder_cubit.dart';
import '../../folder_display/view/folder_widget.dart';
import '../../widget_display/widget_display.dart';

/// A widget displaying the list of travel items of a plan.
class PlanItemList extends StatelessWidget {
  /// The list of travel items.
  final List<TravelItemEntityWrapper> travelItems;

  /// Creates a new instance of [PlanItemList].
  const PlanItemList({
    required this.travelItems,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: travelItems.length,
      itemBuilder: (context, index) {
        final wrapper = travelItems[index];
        if (wrapper.value.isFolderWidget) {
          return BlocProvider(
            key: ValueKey(wrapper.value.id),
            create: (context) => FolderCubit(
              folderId: wrapper.value.id,
              travelItemRepository: $.repo.travelItem(),
            ),
            child: FolderWidget(index: index),
          );
        }
        return TravelWidget(
          key: ValueKey(wrapper.value.id),
          index: index,
          travelItem: wrapper.value,
          child: _buildTile(context, wrapper.value),
        );
      },
    );
  }
}
