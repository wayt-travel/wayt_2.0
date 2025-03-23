part of 'upsert_folder_cubit.dart';

/// State for the upsert folder cubit.
final class UpsertFolderState extends SuperBlocState<WError> {
  /// The name of the folder.
  final String? name;

  /// The icon of the folder.
  final WidgetFolderIcon icon;

  /// The color of the folder.
  final FeatureColor color;

  const UpsertFolderState._({
    required this.name,
    required this.icon,
    required this.color,
    required super.status,
    super.error,
  });

  /// The initial state of the cubit.
  UpsertFolderState.initial(WidgetFolderEntity? folderToUpdate)
      : name = folderToUpdate?.name,
        icon =
            folderToUpdate?.icon ?? WidgetFolderIcon.fromIconData(Icons.folder),
        color = folderToUpdate?.color ?? FeatureColor.blue,
        super.initial();

  @override
  UpsertFolderState copyWith({
    required StateStatus status,
    Option<String?> name = const Option.none(),
    WidgetFolderIcon? icon,
    FeatureColor? color,
  }) =>
      UpsertFolderState._(
        name: name.getOrElse(() => this.name),
        icon: icon ?? this.icon,
        color: color ?? this.color,
        error: error,
        status: status,
      );

  @override
  UpsertFolderState copyWithError(WError error) => UpsertFolderState._(
        name: name,
        icon: icon,
        color: color,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        name,
        icon,
        color,
        ...super.props,
      ];

  /// Returns a [CreateWidgetFolderInput] from the [UpsertFolderState].
  CreateWidgetFolderInput toCreateInput(
    TravelDocumentId travelDocumentId,
    int? index,
  ) =>
      (
        name: name!,
        icon: icon,
        color: color,
        travelDocumentId: travelDocumentId,
        index: index,
      );

  /// Returns a [UpdateWidgetFolderInput] from the [UpsertFolderState].
  UpdateWidgetFolderInput toUpdateInput() => (
        name: name!,
        icon: icon,
        color: color,
      );
}
