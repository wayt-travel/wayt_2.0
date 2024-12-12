import '../../../common/domain/widget_entity.dart';
import '../../../repositories.dart';

class PlanModel extends PlanSummaryModel implements PlanEntity {
  PlanModel({
    required super.createdAt,
    required super.id,
    required super.isDaySet,
    required super.isMonthSet,
    super.plannedAt,
    required super.tags,
    required super.title,
    super.updatedAt,
    required this.widgets,
  });

  @override
  final List<WidgetEntity> widgets;

  @override
  PlanModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [widgets, super.props];
}
