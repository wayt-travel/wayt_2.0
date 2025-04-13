import '../../../../error/errors.dart';
import '../../../../util/util.dart';
import '../../../repositories.dart';
import 'events.dart';

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ WIDGET CREATION ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// Event to create a new widget in the repository.
/// {@template travelItemWidgetCreatedEvent}
/// The widget.order in model is disregarded as it will be recomputed using
/// the provided index based on the existing widgets in the travel document.
/// - If index is `null`, the widget will be added at the end of the list.
/// - If index is out of bounds, the widget will be added at the end of the
/// list.
///
/// The response includes also a map of the widgets of the plan or journal
/// whose order has been updated with the corresponding updated value.
///
/// See [UpsertWidgetOutput].
/// {@endtemplate}
final class TravelItemRepoWidgetCreatedEvent extends RepoV2ItemCreated<String,
        WidgetEntity, ({WidgetModel widget, int? index})>
    implements TravelItemRepositoryEvent<WidgetEntity> {
  /// Creates a new instance of [TravelItemRepoWidgetCreatedEvent].
  /// {@macro travelItemWidgetCreatedEvent}
  const TravelItemRepoWidgetCreatedEvent(super.id, super.input);
}

/// State for when an item is being created in the repository.
final class TravelItemRepoWidgetCreateInProgress
    extends RepoV2ItemCreateInProgress<({WidgetModel widget, int? index}),
        WidgetEntity> implements TravelItemRepositoryState<WidgetEntity> {
  /// Creates a new instance of [TravelItemRepoWidgetCreateInProgress].
  const TravelItemRepoWidgetCreateInProgress(super.input);
}

/// State for when creating an item in the repository fails.
final class TravelItemRepoWidgetCreateFailure extends RepoV2FailureState<
    ({WidgetModel widget, int? index}),
    WidgetEntity,
    WError> implements TravelItemRepositoryState<WidgetEntity> {
  /// Creates a new instance of [TravelItemRepoWidgetCreateFailure].
  /// The [input] contains the input of the creation event.
  /// The [error] contains the error that occurred during the creation.
  const TravelItemRepoWidgetCreateFailure({
    required super.input,
    required super.error,
  });
}

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ FOLDER CREATION ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// Event to create a new folder in the repository.
final class TravelItemRepoFolderCreatedEvent extends RepoV2ItemCreated<String,
        WidgetFolderEntity, CreateWidgetFolderInput>
    implements TravelItemRepositoryEvent<WidgetFolderEntity> {
  /// Creates a new instance of [TravelItemRepoFolderCreatedEvent].
  const TravelItemRepoFolderCreatedEvent(super.id, super.input);
}

/// State for when a folder is being created in the repository.
final class TravelItemRepoFolderCreateInProgress
    extends RepoV2ItemCreateInProgress<CreateWidgetFolderInput,
        WidgetFolderEntity>
    implements TravelItemRepositoryState<WidgetFolderEntity> {
  /// Creates a new instance of [TravelItemRepoFolderCreateInProgress].
  const TravelItemRepoFolderCreateInProgress(super.input);
}

/// State for when creating a folder in the repository fails.
final class TravelItemRepoFolderCreateFailure extends RepoV2FailureState<
    CreateWidgetFolderInput,
    WidgetFolderEntity,
    WError> implements TravelItemRepositoryState<WidgetFolderEntity> {
  /// Creates a new instance of [TravelItemRepoFolderCreateFailure].
  const TravelItemRepoFolderCreateFailure({
    required super.input,
    required super.error,
  });
}

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ COMMON TO ITEMS ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// State for when an item is successfully created in the repository.
final class TravelItemRepoItemCreateSuccess
    extends RepoV2SuccessState<TravelItemEntityWrapper, TravelItemEntity>
    implements TravelItemRepositoryState<TravelItemEntity> {
  /// Creates a new instance of [TravelItemRepoItemCreateSuccess].
  ///
  /// The [output] contains the created widget wrapper.
  const TravelItemRepoItemCreateSuccess(super.output);
}
