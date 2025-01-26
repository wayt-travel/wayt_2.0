part of 'upsert_folder_cubit.dart';

final class UpsertFolderState extends SuperBlocState<WError> {
  final String? name;

  final WidgetFolderIcon icon;

  final FeatureColor color;

  const UpsertFolderState._({
    required this.name,
    required this.icon,
    required this.color,
    required super.status,
    super.error,
  });

  UpsertFolderState.initial()
      : name = null,
        icon = WidgetFolderIcon.fromIconData(Icons.folder),
        color = FeatureColor.blue,
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
}
