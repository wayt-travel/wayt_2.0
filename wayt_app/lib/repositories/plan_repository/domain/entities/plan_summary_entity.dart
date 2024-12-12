import '../domain.dart';

abstract class PlanSummaryEntity implements IPlanEntity {
  String get title;
  List<String> get tags;
  DateTime? get plannedAt;

  bool get isMonthSet;
  bool get isDaySet;

  @override
  PlanSummaryEntity copyWith();
}
