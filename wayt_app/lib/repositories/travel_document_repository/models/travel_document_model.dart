import 'package:a2f_sdk/a2f_sdk.dart';

import 'plan_entity.dart';
import 'travel_document_entity.dart';
import 'travel_document_id.gen.dart';

/// {@template travel_document_model}
/// Model for travel documents (journals and plans are both travel documents).
/// {@endtemplate}
abstract class TravelDocumentModel extends Model
    implements TravelDocumentEntity {
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

  /// {@macro travel_document_model}
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
  T match<T>({
    required T Function(PlanEntity) onPlan,
    required T Function(dynamic) onJournal,
  }) {
    if (isPlan) {
      return onPlan(asPlan);
    } else if (isJournal) {
      return onJournal(asJournal);
    } else {
      throw ArgumentError(
        'This entity is neither a plan nor a journal.',
      );
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        createdAt,
        updatedAt,
      ];
}
