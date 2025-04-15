import '../../../../util/util.dart';
import '../../../repositories.dart';

//*                          ╔═════════════════╗
//*╠═════════════════════════╣  FOLDER UPDATE  ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// Event to update an existing folder in the repository.
final class TravelItemRepoFolderUpdatedEvent extends RepoV2ItemUpdated<String,
        WidgetFolderEntity, UpdateWidgetFolderInput>
    implements TravelItemRepositoryEvent<WidgetFolderEntity> {
  /// Creates a new instance of [TravelItemRepoFolderUpdatedEvent].
  const TravelItemRepoFolderUpdatedEvent({
    required String id,
    required UpdateWidgetFolderInput input,
    required this.travelDocumentId,
  }) : super(id, input);

  /// The ID of the travel document to which the folder belongs.
  final TravelDocumentId travelDocumentId;

  @override
  List<Object?> get props => [travelDocumentId, ...super.props];
}

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ COMMON TO ITEMS ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// State for when an item is successfully updated in the repository.
final class TravelItemRepoItemUpdateSuccess
    extends RepoV2ItemUpdateSuccess<TravelItemEntityWrapper, TravelItemEntity>
    implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemUpdateSuccess].
  const TravelItemRepoItemUpdateSuccess(super.previous, super.updated);
}
