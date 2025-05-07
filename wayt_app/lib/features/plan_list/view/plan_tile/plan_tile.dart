import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';
import 'plan_date_text.dart';

/// A tile of a Travel Plan displayed in the list of plans of the user.
class PlanTile extends StatelessWidget {
  /// The plan summary to display.
  final PlanEntity plan;

  /// The index of the plan in the list.
  final int index;

  /// The accent color of the plan to colorize a bit the tile.
  final Color accentColor;

  /// Creates a plan tile.
  const PlanTile({
    required this.plan,
    required this.index,
    required this.accentColor,
    super.key,
  });

  Future<bool> _delete(BuildContext context) async {
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
          trigger: () => cubit.onDelete(plan.id),
          listenWhen: (previous, current) =>
              current.status.isSuccess || current.status.isFailure,
          listener: (context, state) {
            context.navRoot.pop();
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

  Future<void> _onLongPress(BuildContext context) async {
    return ModalBottomSheet.of(context).showActions(
      actions: [
        ModalBottomSheetActions.edit(context).copyWith(
          onTap: (context) => UpsertPlanModal.showForEditing(
            context,
            plan: plan,
          ),
        ),
        ModalBottomSheetActions.divider,
        ModalBottomSheetActions.delete(context).copyWith(
          // onTap: _delete does not work because the method have to use the
          // outer context
          onTap: (_) => _delete(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: $insets.sm.asPaddingH,
      onTap: () => PlanPage.push(
        context,
        planId: plan.id,
        planSummary: plan,
      ),
      onLongPress: () => _onLongPress(context),
      leading: CircleAvatar(
        backgroundColor: accentColor,
        child: Text(
          '${index + 1}',
          style: context.tt.bodyMedium?.copyWith(
            color: context.col.onInverseSurface,
          ),
        ),
      ),
      title: Text(plan.name),
      titleTextStyle: context.tt.bodyLarge?.copyWith(
        color: accentColor,
      ),
      subtitle: PlanDateText.ofPlan(plan: plan),
    );
  }
}
