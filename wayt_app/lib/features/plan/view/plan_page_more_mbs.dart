import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../../travel_document/bloc/reorder_items/reorder_items_cubit.dart';

/// Modal bottom sheet for the plan page shown when the user taps on the more
/// button in the app bar.
sealed class PlanPageMoreMbs {
  /// Shows the modal bottom sheet.
  static void show(BuildContext context) {
    final isReordering = context.read<ReorderItemsCubit>().isReordering;
    ModalBottomSheet.of(context).showActions<void>(
      actions: [
        ModalBottomSheetAction(
          iconData: Icons.swap_vert,
          title: 'Reorder widgets',
          onTap: (_) => context.read<ReorderItemsCubit>().let(
                (cubit) =>
                    cubit.toggleReordering(isReordering: !cubit.isReordering),
              ),
          subtitle: isReordering ? 'ACTIVE' : null,
          subtitleStyle: isReordering
              ? TextStyle(
                  color: FeatureColor.green.toFlutterColor(context),
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),
        ModalBottomSheetActions.divider,
        ModalBottomSheetActions.delete(context),
      ],
    );
  }
}
