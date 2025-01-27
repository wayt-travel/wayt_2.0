import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reorder_items/reorder_items_cubit.dart';

/// An icon button that toggles the reordering of items in a travel document
/// or folder.
///
/// This widget must have a [ReorderItemsCubit] ancestor.
class TravelDocumentReorderIconButton extends StatelessWidget {
  /// Creates a new instance of [TravelDocumentReorderIconButton].
  const TravelDocumentReorderIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReorderItemsCubit, ReorderItemsState, bool>(
      selector: (state) => state.isReordering,
      builder: (context, isReordering) {
        return IconButton.filled(
          icon: const Icon(Icons.swap_vert),
          selectedIcon: Icon(
            Icons.swap_vert,
            color: context.col.onPrimary,
          ),
          isSelected: isReordering,
          onPressed: () {
            context
                .read<ReorderItemsCubit>()
                .toggleReordering(isReordering: !isReordering);
          },
        );
      },
    );
  }
}
