import '../plan_repository.dart';

/// Travel plan entity.
abstract interface class PlanEntity implements PlanSummaryEntity {
  /// The items contained in the plan.
  List<String> get itemIds;
}
