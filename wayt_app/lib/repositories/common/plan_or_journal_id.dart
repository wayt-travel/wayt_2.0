import 'package:equatable/equatable.dart';

/// Wrapper class for either a plan or a journal id.
final class PlanOrJournalId extends Equatable {
  final String? journalId;
  final String? planId;

  const PlanOrJournalId.journal(String this.journalId) : planId = null;
  const PlanOrJournalId.plan(String this.planId) : journalId = null;

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
      '$PlanOrJournalId(id: $id, ${isJournal ? 'JOURNAL' : 'PLAN'})';
}
