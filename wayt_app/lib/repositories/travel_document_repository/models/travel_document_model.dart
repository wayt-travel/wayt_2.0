import 'package:a2f_sdk/a2f_sdk.dart';

import 'plan_entity.dart';
import 'travel_document_entity.dart';
import 'travel_document_id.dart';

/// Model for all journals and plans.
class TravelDocumentModel extends Model implements TravelDocumentEntity {
  /// The name of the travel plan.
  @override
  final String name;

  /// The id of the owner of the travel plan.
  @override
  final String userId;

  @override
  final DateTime createdAt;

  @override
  final String id;

  @override
  final DateTime? updatedAt;

  const TravelDocumentModel({
    required this.name,
    required this.userId,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  PlanEntity get asPlan => isPlan
      ? this as PlanEntity
      : throw StateError('The entity is not a plan.');
  @override
  Object get asJournal => throw UnimplementedError();

  @override
  bool get isPlan => this is PlanEntity;

  @override
  bool get isJournal => !isPlan;

  @override
  TravelDocumentId get tid =>
      isPlan ? TravelDocumentId.plan(id) : TravelDocumentId.journal(id);

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'name': name,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        createdAt,
        updatedAt,
      ];
}
