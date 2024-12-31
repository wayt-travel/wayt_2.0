import 'package:a2f_sdk/a2f_sdk.dart';

import '../../widget_repository/models/widget_entity.dart';
import 'travel_item_entity.dart';

/// Base model class for [TravelItemEntity] implementations.
abstract class TravelItemModel extends Model implements TravelItemEntity {
  @override
  final String id;

  @override
  final String? journalId;

  @override
  final String? planId;

  @override
  final DateTime createdAt;

  @override
  final DateTime? updatedAt;

  const TravelItemModel({
    required this.createdAt,
    required this.id,
    required this.journalId,
    required this.planId,
    required this.updatedAt,
  }) : assert(
          (journalId != null && planId == null) ||
              (journalId == null && planId != null),
          'One and only one of journalId [=$journalId] and planId [=$planId] '
          'must be not null.',
        );

  @override
  WidgetEntity get asWidget => isWidget
      ? this as WidgetEntity
      : throw StateError('The item is not a widget.');

  @override
  // FIXME: check FolderWidget type.
  bool get isFolderWidget => this is! WidgetEntity;

  @override
  bool get isWidget => this is WidgetEntity;

  @override
  String get journalOrPlanId => journalId ?? planId!;

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'journalId': journalId,
        'planId': planId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        journalId,
        planId,
        createdAt,
        updatedAt,
      ];
}
