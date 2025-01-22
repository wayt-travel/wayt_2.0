import 'package:equatable/equatable.dart';

/// Wrapper class for either a plan or a journal id.
final class TravelDocumentId extends Equatable {
  final String? journalId;
  final String? planId;

  const TravelDocumentId.journal(String this.journalId) : planId = null;
  const TravelDocumentId.plan(String this.planId) : journalId = null;

  bool get isJournal => journalId != null;
  bool get isPlan => planId != null;

  String get id => journalId ?? planId!;

  void ifJournal(void Function(String journalId) callback) {
    if (isJournal) {
      callback(journalId!);
    }
  }

  void ifPlan(void Function(String planId) callback) {
    if (isPlan) {
      callback(planId!);
    }
  }

  @override
  List<Object?> get props => [journalId, planId];

  @override
  String toString() =>
      '$TravelDocumentId(id: $id, ${isJournal ? 'JOURNAL' : 'PLAN'})';
}
