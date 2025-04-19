import '../../../../util/util.dart';
import '../../../repositories.dart';

//*                          ╔═════════════════╗
//*╠═════════════════════════╣  ITEM DELETION  ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// Event for when an item is being deleted from the repository.
final class TravelItemRepoItemDeletedEvent
    extends RepoV2ItemDeleted<String, TravelItemEntity>
    implements TravelItemRepositoryEvent<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemDeletedEvent].
  const TravelItemRepoItemDeletedEvent(super.id);
}

/// State for when an item is successfully deleted from the repository.
final class TravelItemRepoItemDeleteSuccess
    extends TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemDeleteSuccess].
  const TravelItemRepoItemDeleteSuccess(this.itemWrapper);

  /// The wrapper of the item that was deleted.
  final TravelItemEntityWrapper itemWrapper;

  @override
  List<Object?> get props => [itemWrapper];

  @override
  String toString() => '$runtimeType { itemWrapper: $itemWrapper }';
}
