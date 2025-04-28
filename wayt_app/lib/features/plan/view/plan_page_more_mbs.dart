import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../../features.dart';

/// Modal bottom sheet for the plan page shown when the user taps on the more
/// button in the app bar.
sealed class PlanPageMoreMbs {
  static Future<bool> _delete(
    BuildContext context, {
    required String id,
  }) async {
    return WConfirmDialog.show(
      context: context,
      // FIXME: l10n
      title: 'Are you sure?',
      confirmActionColor: context.col.error,
      onConfirm: () async {
        final cubit = DeletePlanCubit(
          travelDocumentRepository: GetIt.I.get(),
        );

        await context.navRoot
            .pushBlocListenerBarrier<DeletePlanCubit, DeletePlanState>(
          bloc: cubit,
          trigger: () => cubit.onDelete(id),
          listenWhen: (previous, current) =>
              current.status.isSuccess || current.status.isFailure,
          listener: (context, state) {
            context.navRoot.pop();
            if (state.status.isSuccess) {
              context.navRoot.pop();
            }
            if (state.status.isFailure) {
              SnackBarHelper.I.showError(
                context: context,
                message: state.error!.userIntlMessage(context),
              );
            }
          },
        );

        cubit.close().ignore();
      },
    );
  }

  /// Shows the modal bottom sheet.
  static void show(BuildContext context) {
    final isReordering = context.read<ReorderItemsCubit>().isReordering;
    final planId = context.read<TravelDocumentCubit>().travelDocumentId.id;
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
        ModalBottomSheetActions.delete(context).copyWith(
          onTap: (_) => _delete(context, id: planId),
        ),
      ],
    );
  }
}
