part of 'widget_repository.dart';

class _WidgetRepositoryImpl
    extends Repository<String, WidgetEntity, WidgetRepositoryState>
    implements WidgetRepository {
  StreamSubscription<TravelItemRepositoryState>?
      _travelItemRepositorySubscription;

  final TravelItemRepository travelItemRepository;

  /// Private constructor.
  _WidgetRepositoryImpl(this.travelItemRepository) {
    _travelItemRepositorySubscription =
        travelItemRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is TravelItemRepositoryTravelItemAdded &&
          repoState.item.isWidget) {
        emit(WidgetRepositoryWidgetAdded(repoState.item.asWidget));
      } else if (repoState is TravelItemRepositoryTravelItemFetched &&
          repoState.item.isWidget) {
        emit(WidgetRepositoryWidgetFetched(repoState.item.asWidget));
      } else if (repoState is TravelItemRepositoryTravelItemUpdated &&
          repoState.updatedItem.isWidget) {
        emit(
          WidgetRepositoryWidgetUpdated(
            repoState.previousItem?.asWidget,
            repoState.updatedItem.asWidget,
          ),
        );
      } else if (repoState is TravelItemRepositoryTravelItemDeleted &&
          repoState.item.isWidget) {
        emit(WidgetRepositoryWidgetDeleted(repoState.item.asWidget));
      }
    });
  }

  @override
  Future<void> close() async {
    _travelItemRepositorySubscription?.cancel().ignore();
    await super.close();
  }

  @override
  Cache<String, WidgetEntity> get cache => Cache.fromMap(
        Map.fromEntries(
          travelItemRepository.cache.items.values
              .whereType<WidgetEntity>()
              .map((widget) => MapEntry(widget.id, widget)),
        ),
      );

  @override
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index) =>
      travelItemRepository.createWidget(widget, index);

  @override
  Future<void> delete(String id) => travelItemRepository.deleteWidget(id);
}
