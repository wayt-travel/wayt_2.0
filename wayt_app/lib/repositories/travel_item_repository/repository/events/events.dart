import 'package:a2f_sdk/a2f_sdk.dart';

import '../../../../util/util.dart';
import '../../../repositories.dart';

export 'common_states.dart';
export 'item_creation_event.dart';
export 'item_deletion_event.dart';
export 'items_reordered_event.dart';

/// Base event for the [TravelItemRepository].
interface class TravelItemRepositoryEvent<E extends TravelItemEntity>
    extends RepositoryV2Event<E> {}

/// Base state for the [TravelItemRepository].
abstract class TravelItemRepositoryState<E extends TravelItemEntity>
    extends RepositoryV2State<E> {
  /// Creates a new instance of [TravelItemRepositoryState].
  const TravelItemRepositoryState();
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => false;
}

/// Event for when items are added to the repository.
final class TravelItemRepoItemsAddedEvent
    with ModelToStringMixin
    implements TravelItemRepositoryEvent<TravelItemEntity> {
  /// Creates a new instance.
  const TravelItemRepoItemsAddedEvent({
    required this.travelItems,
    this.shouldEmit = true,
  });

  /// The travel items that were added.
  final Iterable<TravelItemEntityWrapper> travelItems;

  /// Whether the items should be emitted.
  final bool shouldEmit;

  @override
  List<Object?> get props => [
        travelItems,
        shouldEmit,
      ];

  @override
  bool? get stringify => false;

  @override
  Map<String, dynamic> $toMap() => {
        'travelItems.length': travelItems.length,
        'shouldEmit': shouldEmit,
      };
}
