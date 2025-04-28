import 'package:a2f_sdk/a2f_sdk.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

/// Base state for the [TravelItemRepository].
abstract class TravelItemRepositoryState<E extends TravelItemEntity>
    extends RepositoryV3State<E> {
  /// Creates a new instance of [TravelItemRepositoryState].
  const TravelItemRepositoryState();
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

/// State for when the order of items is updated successfully.
final class TravelItemRepoItemsReorderSuccess
    extends TravelItemRepositoryState<WidgetFolderEntity>
    with ModelToStringMixin {
  /// Creates a new instance.
  const TravelItemRepoItemsReorderSuccess({
    required this.travelDocumentId,
    required this.updatedOrders,
  });

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The updated orders of the items.
  /// The key is the ID of the item, and the value is the new order.
  /// If an item is not present in the map, it means that its order has not been
  /// updated.
  final Map<String, int> updatedOrders;

  @override
  List<Object?> get props => [travelDocumentId, updatedOrders];

  @override
  Map<String, dynamic> $toMap() => {
        'travelDocumentId': travelDocumentId,
        'updatedOrders.length': updatedOrders.length,
      };
}

/// State for when the items in a travel document are successfully fetched.
final class TravelItemRepoItemCollectionFetchSuccess
    extends TravelItemRepositoryState<TravelItemEntity>
    with ModelToStringMixin {
  /// Creates a new instance.
  const TravelItemRepoItemCollectionFetchSuccess(this.itemWrappers);

  /// List of item wrappers.
  final List<TravelItemEntityWrapper> itemWrappers;

  @override
  List<Object?> get props => [itemWrappers];

  @override
  Map<String, dynamic> $toMap() => {
        'itemWrappers.length': itemWrappers.length,
      };
}

/// State for when an item is successfully created in the repository.
final class TravelItemRepoItemCreateSuccess
    implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemCreateSuccess].
  ///
  /// The [itemWrapper] contains the created widget wrapper.
  const TravelItemRepoItemCreateSuccess(this.itemWrapper);

  /// The item wrapper that contains the created widget.
  final TravelItemEntityWrapper itemWrapper;

  @override
  List<Object?> get props => [itemWrapper];

  @override
  bool? get stringify => true;
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

/// State for when an item is successfully updated in the repository.
final class TravelItemRepoItemUpdateSuccess
    extends RepoV3ItemUpdateSuccess<TravelItemEntityWrapper, TravelItemEntity>
    implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemUpdateSuccess].
  const TravelItemRepoItemUpdateSuccess(super.previous, super.updated);
}
