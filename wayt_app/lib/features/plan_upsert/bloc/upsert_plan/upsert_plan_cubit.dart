import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../core/core.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';

part 'upsert_plan_state.dart';

/// Cubit to handle the creation or update of a travel plan.
class UpsertPlanCubit extends Cubit<UpsertPlanState> with LoggerMixin {
  /// The travel document repository.
  final TravelDocumentRepository travelDocumentRepository;

  /// The authentication repository.
  final AuthRepository authRepository;

  /// The plan entity to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new plan will be created.
  final PlanEntity? planToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => planToUpdate != null;

  /// Creates a new [UpsertPlanCubit].
  UpsertPlanCubit({
    required this.planToUpdate,
    required this.authRepository,
    required this.travelDocumentRepository,
  }) : super(UpsertPlanState.initial(planToUpdate));

  /// Updates the name of the plan.
  void updateName(String name) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        name: name.trim(),
      ),
    );
  }

  /// Updates the planned date of the plan.
  void updatePlannedAt({
    required DateTime? plannedAt,
    required bool isMonthSet,
    required bool isDaySet,
  }) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        plannedAt: Option.of(plannedAt),
        isMonthSet: isMonthSet,
        isDaySet: isDaySet,
      ),
    );
  }

  /// Validates the current state of the cubit.
  SingleValidationResult<dynamic> validate(BuildContext? context) {
    return TravelDocumentEntity.getNameValidator(context)
        .validateValue(state.name?.trim());
  }

  /// Submits the plan to the repository.
  Future<void> submit() async {
    logger.d(
      isUpdate ? 'Updating plan $planToUpdate...' : 'Creating new plan...',
    );
    emit(state.copyWith(status: StateStatus.progress));

    if (!validate(null).isValid) {
      logger.wtf(
        'Invalid cubit state $state. It should have been validated before '
        'submitting!!!',
      );
      emit(state.copyWithError($.errors.validation.invalidCubitState));
      return;
    }

    try {
      // Sanitize date
      var plannedAt = state.plannedAt;
      var isDaySet = state.isDaySet;
      var isMonthSet = state.isMonthSet;
      if (plannedAt == null) {
        isDaySet = false;
        isMonthSet = false;
      } else {
        plannedAt = DateTime.utc(
          plannedAt.year,
          isMonthSet ? plannedAt.month : 1,
          isDaySet ? plannedAt.day : 1,
        );
      }

      if (!isUpdate) {
        await travelDocumentRepository.createPlan(
          CreatePlanInput(
            isDaySet: isDaySet,
            isMonthSet: isMonthSet,
            plannedAt: plannedAt,
            name: state.name!.trim(),
            tags: List.empty(),
            userId: authRepository.getOrThrow().user!.id,
          ),
        );
      } else {
        await travelDocumentRepository.updatePlan(
          planToUpdate!.id,
          (
            isDaySet: isDaySet,
            isMonthSet: isMonthSet,
            plannedAt: plannedAt,
            name: state.name!.trim(),
            tags: List.empty(),
          ),
        );
      }

      emit(state.copyWith(status: StateStatus.success));
    } catch (e, s) {
      logger.e('Error submitting plan creation/modification: $e', e, s);
      emit(state.copyWithError(e.errorOrGeneric));
      return;
    }
  }
}
