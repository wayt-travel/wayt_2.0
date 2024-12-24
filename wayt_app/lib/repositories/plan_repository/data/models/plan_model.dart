import '../../../common/common.dart';
import '../../../repositories.dart';

class PlanModel extends PlanSummaryModel implements PlanEntity {
  PlanModel({
    required super.createdAt,
    required super.uuid,
    required super.isDaySet,
    required super.isMonthSet,
    super.plannedAt,
    required super.tags,
    required super.title,
    super.updatedAt,
    required this.widgets,
  });

  @override
  final List<PlanItem> widgets;

  @override
  PlanModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [widgets, super.props];
}
