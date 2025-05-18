import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../util/util.dart';
import '../../../widgets/widgets.dart';
import '../../plan_list/view/plan_tile/plan_date_text.dart';
import '../bloc/bloc.dart';
import 'view.dart';

/// A modal screen displaying a form to create or update a travel plan.
class UpsertPlanModal extends StatelessWidget {
  /// The plan to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new plan will be created.
  final PlanEntity? plan;

  const UpsertPlanModal._({required this.plan});

  static Future<void> _push(BuildContext context, PlanEntity? plan) =>
      context.navRoot.push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => BlocProvider(
            create: (context) => UpsertPlanCubit(
              authRepository: $.repo.auth(),
              travelDocumentRepository: $.repo.travelDocument(),
              planToUpdate: plan,
            ),
            child: Form(
              child: UpsertPlanModal._(plan: plan),
            ),
          ),
        ),
      );

  /// Shows a modal for creating a new travel plan.
  static void showForCreating(BuildContext context) => _push(context, null);

  /// Shows a modal for editing an existing travel [plan].
  static void showForEditing(
    BuildContext context, {
    required PlanEntity plan,
  }) =>
      _push(context, plan);

  bool get _isEditing => plan != null;

  Future<void> _submit(BuildContext context) async {
    if (Form.maybeOf(context)?.validate() != true) {
      return;
    }
    final result = context.read<UpsertPlanCubit>().validate(context);

    if (!result.isValid) {
      SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: 'Please fill in all required fields',
      );
    } else {
      await context.navRoot
          .pushBlocListenerBarrier<UpsertPlanCubit, UpsertPlanState>(
        bloc: context.read<UpsertPlanCubit>(),
        trigger: () => context.read<UpsertPlanCubit>().submit(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // FIXME: l10n
          _isEditing ? 'Edit travel plan' : 'New travel plan',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          $insets.xs.asVSpan.asSliver,
          BlocSelector<UpsertPlanCubit, UpsertPlanState, String?>(
            selector: (state) => state.name,
            builder: (context, name) => SliverPadding(
              padding: $insets.screenH.asPaddingH,
              sliver: TextFormField(
                initialValue: name,
                onChanged: (value) =>
                    context.read<UpsertPlanCubit>().updateName(value),
                validator: TravelDocumentEntity.getNameValidator(context)
                    .formFieldValidator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  // FIXME: l10n
                  labelText: 'Name',
                ),
              ).asSliver,
            ),
          ),
          $insets.sm.asVSpan.asSliver,
          BlocSelector<UpsertPlanCubit, UpsertPlanState,
              ({bool isDaySet, bool isMonthSet, DateTime? plannedAt})>(
            selector: (state) => (
              plannedAt: state.plannedAt,
              isMonthSet: state.isMonthSet,
              isDaySet: state.isDaySet,
            ),
            builder: (context, selectorState) => SliverPadding(
              padding: $insets.screenH.asPaddingH,
              sliver: WActionCardTheme(
                child: Card.outlined(
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: context.col.primary,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: context.col.primary,
                    ),
                    title: const Text(
                      // FIXME: l10n
                      'Choose a date for your travel',
                    ),
                    subtitle: PlanDateText(
                      dateTime: selectorState.plannedAt,
                      isMonthSet: selectorState.isMonthSet,
                      isDaySet: selectorState.isDaySet,
                    ),
                    subtitleTextStyle: TextStyle(
                      color: context.col.primary,
                    ),
                    onTap: () async {
                      await PlanDatePicker.show(
                        context,
                        onPick: context.read<UpsertPlanCubit>().updatePlannedAt,
                        initialDate:
                            context.read<UpsertPlanCubit>().state.plannedAt,
                      );
                    },
                  ),
                ).asSliver,
              ),
            ),
          ),
          getScrollableBottomPadding(context).asVSpan.asSliver,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submit(context),
        child: const Icon(Icons.save),
      ),
    );
  }
}
