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
  String toString() => '$runtimeType { }';
}
