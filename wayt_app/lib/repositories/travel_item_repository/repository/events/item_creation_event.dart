import '../../../../util/util.dart';
import '../../../repositories.dart';

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
final class TravelItemRepoWidgetCreatedEvent
    extends TravelItemRepositoryEvent<WidgetEntity> {
  /// Creates a new instance of [TravelItemRepoWidgetCreatedEvent].
  /// {@macro travelItemWidgetCreatedEvent}
  TravelItemRepoWidgetCreatedEvent({
    required this.widget,
    this.index,
  });

  /// The widget to be created.
  ///
  /// The `order` property in the model is disregarded as it will be recomputed
  /// using the provided index based on the existing widgets in the travel
  /// document.
  final WidgetModel widget;

  /// The index where the widget will be added.
  final int? index;

  @override
  List<Object?> get props => [widget, index];
}

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ FOLDER CREATION ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

/// Event to create a new folder in the repository.
final class TravelItemRepoFolderCreatedEvent
    extends RepoV2ItemCreated<WidgetFolderEntity, CreateWidgetFolderInput>
    implements TravelItemRepositoryEvent<WidgetFolderEntity> {
  /// Creates a new instance of [TravelItemRepoFolderCreatedEvent].
  const TravelItemRepoFolderCreatedEvent(super.input);
}

//*                          ╔═════════════════╗
//*╠═════════════════════════╣ COMMON TO ITEMS ╠═══════════════════════════════╣
//*                          ╚═════════════════╝

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
