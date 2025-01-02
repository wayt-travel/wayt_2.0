import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// Base model class for [TravelItemEntity] implementations.
abstract class TravelItemModel extends Model implements TravelItemEntity {
  @override
  final String id;

  @override
  final PlanOrJournalId planOrJournalId;

  @override
  final DateTime createdAt;

  @override
  final DateTime? updatedAt;

  const TravelItemModel({
    required this.planOrJournalId,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
  });

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
  Map<String, dynamic> $toMap() => {
        'id': id,
        'planOrJournalId': planOrJournalId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        planOrJournalId,
        createdAt,
        updatedAt,
      ];
}
