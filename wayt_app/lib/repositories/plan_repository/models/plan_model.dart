import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

class PlanModel extends PlanSummaryModel implements PlanEntity {
  @override
  final List<String> itemIds;

  PlanModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.isDaySet,
    required super.isMonthSet,
    required super.tags,
    required super.createdAt,
    required super.plannedAt,
    required super.updatedAt,
    required this.itemIds,
  });

  @override
  PlanModel copyWith({
    Optional<DateTime?> plannedAt = const Optional.absent(),
    bool? isDaySet,
    bool? isMonthSet,
    String? name,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? itemIds,
  }) =>
      PlanModel(
        id: id,
        userId: userId,
        plannedAt: plannedAt.orElseIfAbsent(this.plannedAt),
        isDaySet: isDaySet ?? this.isDaySet,
        isMonthSet: isMonthSet ?? this.isMonthSet,
        name: name ?? this.name,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        itemIds: itemIds ?? this.itemIds,
      );

  @override
  List<Object?> get props => [itemIds, super.props];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'items': itemIds.join(', '),
      };
}
