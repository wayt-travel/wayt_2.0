part of 'summary_helper_repository.dart';

class _SummaryHelperRepositoryImpl
    extends Repository<PlanOrJournalId, bool, SummaryHelperRepositoryState>
    implements SummaryHelperRepository {
  _SummaryHelperRepositoryImpl();

  @override
  void unset(PlanOrJournalId id) {
    cache.delete(id);
    emit(SummaryHelperRepositoryChanged(id: id, isFullyLoaded: false));
  }

  @override
  bool isFullyLoaded(PlanOrJournalId id) {
    return cache.get(id) ?? false;
  }

  @override
  void setFullyLoaded(PlanOrJournalId id) {
    cache.save(id, true);
    emit(SummaryHelperRepositoryChanged(id: id, isFullyLoaded: true));
  }
}
