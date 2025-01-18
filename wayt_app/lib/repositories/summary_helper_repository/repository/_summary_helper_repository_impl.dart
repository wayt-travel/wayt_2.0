part of 'summary_helper_repository.dart';

class _SummaryHelperRepositoryImpl
    extends Repository<TravelDocumentId, bool, SummaryHelperRepositoryState>
    implements SummaryHelperRepository {
  _SummaryHelperRepositoryImpl();

  @override
  void unset(TravelDocumentId id) {
    cache.delete(id);
    logger.d('Fully loaded status for $id unset');
    emit(SummaryHelperRepositoryChanged(id: id, isFullyLoaded: false));
  }

  @override
  bool isFullyLoaded(TravelDocumentId id) {
    return cache.get(id) ?? false;
  }

  @override
  void setFullyLoaded(TravelDocumentId id) {
    cache.save(id, true);
    logger.d('Fully loaded status for $id set to true');
    emit(SummaryHelperRepositoryChanged(id: id, isFullyLoaded: true));
  }
}
