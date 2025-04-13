import 'package:equatable/equatable.dart';

import '../../../../error/errors.dart';
import '../../../../util/util.dart';
import '../../../repositories.dart';
import 'events.dart';

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ ITEMS REORDERED ╠══════════════════════════════╣
//*                          ╚═════════════════╝

/// Input for reordering items in a travel document via
/// [TravelItemReorderedEvent].
///
/// /// Reorders the items in a travel document based on the provided
/// [reorderedItemIds].
///

final class TravelItemReorderedInput extends Equatable {
  /// Creates a new instance of [TravelItemReorderedInput].
  const TravelItemReorderedInput({
    required this.travelDocumentId,
    required this.reorderedItemIds,
    this.folderId,
  });

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The reordered item IDs.
  ///
  /// This list should contain all the item IDs in the travel document.
  final List<String> reorderedItemIds;

  /// The folder ID.
  ///
  /// If `null`, the items are reordered in the root of the travel document.
  /// If not `null`, the items are reordered in the folder with the given ID.
  final String? folderId;

  @override
  List<Object?> get props => [
        travelDocumentId,
        reorderedItemIds,
        folderId,
      ];
}

/// Event for when the items in a travel document are reordered.
///
/// This event supports reordering the items in the root of the travel
/// document as well as the items contained in a folder. For the latter, the
/// folderId should be provided in the input.
///
/// If reorderedItemIds does not match the list of items currently contained
/// in the repo for the travel document with travelDocumentId the repository
/// will throw an [ArgumentError].
final class TravelItemReorderedEvent extends RepoV2ItemUpdated<String,
        TravelItemEntity, TravelItemReorderedInput>
    implements TravelItemRepositoryEvent<TravelItemEntity> {
  /// Creates a new instance of [TravelItemReorderedEvent].
  const TravelItemReorderedEvent(super.id, super.input);
}

/// State for when the items in a travel document are being reordered.
final class TravelItemReorderInProgress
    extends RepoV2InProgressState<TravelItemReorderedInput, TravelItemEntity>
    implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemReorderInProgress].
  const TravelItemReorderInProgress(super.input);
}

/// State for when the items in a travel document are successfully reordered.
final class TravelItemRepoItemsReorderSuccess
    extends TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemsReorderSuccess].
  const TravelItemRepoItemsReorderSuccess({
    required this.travelDocumentId,
    required this.updatedItemsOrder,
  });

  /// The updated items order.
  final Map<String, int> updatedItemsOrder;

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  @override
  List<Object?> get props => [
        travelDocumentId,
        updatedItemsOrder,
      ];
}

/// State for when an error occurs while reordering items in a travel document.
final class TravelItemReorderFailure extends RepoV2FailureState<
    TravelItemReorderedInput,
    TravelItemEntity,
    WError> implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemReorderFailure].
  const TravelItemReorderFailure({
    required super.input,
    required super.error,
  });
}
