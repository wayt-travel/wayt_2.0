import 'package:equatable/equatable.dart';

/// Wrapper class for either a plan or a journal id.
final class TravelDocumentId extends Equatable {
  /// The ID of the journal.
  ///
  /// If `null`, the ID is that of a plan.
  final String? journalId;

  /// The ID of the plan.
  ///
  /// If `null`, the ID is that of a journal.
  final String? planId;

  /// Creates a travel document ID for a journal.
  const TravelDocumentId.journal(String this.journalId) : planId = null;

  /// Creates a travel document ID for a plan.
  const TravelDocumentId.plan(String this.planId) : journalId = null;

  /// Whether the ID is that of a journal.
  bool get isJournal => journalId != null;

  /// Whether the ID is that of a plan.
  bool get isPlan => planId != null;

  /// The raw string ID of the travel document.
  String get id => journalId ?? planId!;

  @override
  List<Object?> get props => [journalId, planId];

  @override
  String toString() =>
      '$TravelDocumentId($id, ${isJournal ? 'JOURNAL' : 'PLAN'})';
}
