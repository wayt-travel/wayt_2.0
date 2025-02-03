/// Input to create a new plan.
final class CreatePlanInput {
  /// Whether the day is set in the [plannedAt] date.
  final bool isDaySet;

  /// Whether the month is set in the [plannedAt] date.
  final bool isMonthSet;

  /// The planned date of the plan.
  final DateTime? plannedAt;

  /// The tags of the plan.
  final List<String> tags;

  /// The name of the plan.
  final String name;

  /// The id of the user who created the plan.
  final String userId;

  /// Creates a new instance of [CreatePlanInput].
  CreatePlanInput({
    required this.isDaySet,
    required this.isMonthSet,
    required this.tags,
    required this.name,
    required this.userId,
    required this.plannedAt,
  });
}

/// Input to update an existing plan.
typedef UpdatePlanInput = ();
