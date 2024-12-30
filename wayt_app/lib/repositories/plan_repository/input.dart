/// Input to create a new plan.
typedef CreatePlanInput = ({
  bool isDaySet,
  bool isMonthSet,
  DateTime? plannedAt,
  List<String> tags,
  String name,
  String userId,
});

/// Input to update an existing plan.
typedef UpdatePlanInput = ();
