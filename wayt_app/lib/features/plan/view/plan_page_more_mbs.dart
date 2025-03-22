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
  static Future<void> _delete(
    BuildContext context, {
    required String id,
  }) async {
    return ModalBottomSheet.of(context).showActions(
      title: Text(
        // FIXME: l10n
        'Are you sure?',
        style: context.tt.labelLarge,
      ),
      actions: [
        ModalBottomSheetActions.delete(context).copyWith(
          onTap: (ctx) {
            final cubit = DeletePlanCubit(
              travelDocumentRepository: GetIt.I.get(),
            );
            if (context.mounted) {
              context.navRoot
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
                      message: state.error.toString(),
                    );
                  }
                },
              );
            }
          },
        ),
      ],
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
