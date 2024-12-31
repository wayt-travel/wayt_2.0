part of 'travel_item_repository.dart';

class _TravelItemRepositoryImpl
    extends Repository<String, TravelItemEntity, TravelItemRepositoryState>
    implements TravelItemRepository {
  StreamSubscription<WidgetRepositoryState>? _widgetRepositorySubscription;

  final WidgetRepository widgetRepository;

  @override
  Cache<String, TravelItemEntity> get cache =>
      // TODO: add widget folder cache
      Cache.from(widgetRepository.cache);

  _TravelItemRepositoryImpl({required this.widgetRepository}) {
    _widgetRepositorySubscription = widgetRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is WidgetRepositoryWidgetAdded) {
        emit(TravelItemRepositoryTravelItemAdded(repoState.item));
      } else if (repoState is WidgetRepositoryWidgetFetched) {
        emit(TravelItemRepositoryTravelItemFetched(repoState.item));
      } else if (repoState is WidgetRepositoryWidgetUpdated) {
        emit(
          TravelItemRepositoryTravelItemUpdated(
            repoState.previousItem,
            repoState.updatedItem,
          ),
        );
      } else if (repoState is WidgetRepositoryWidgetDeleted) {
        emit(TravelItemRepositoryTravelItemDeleted(repoState.item));
      }
    });
    // TODO: add subscription to widget folder repository
  }

  @override
  Future<void> close() {
    _widgetRepositorySubscription?.cancel().ignore();
    return super.close();
  }

  @override
  List<TravelItemEntity> getAllOfJournal(String journalId) =>
      // TODO: add widget folder repository getter
      widgetRepository.getAllOfJournal(journalId);

  @override
  List<TravelItemEntity> getAllOfPlan(String planId) =>
      // TODO: add widget folder repository getter
      widgetRepository.getAllOfPlan(planId);
}
