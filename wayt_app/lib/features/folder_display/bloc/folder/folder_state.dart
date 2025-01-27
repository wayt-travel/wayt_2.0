part of 'folder_cubit.dart';

/// The parent state for all states of the [FolderCubit].
@immutable
sealed class FolderState extends Equatable {
  /// The folder entity wrapper.
  final WidgetFolderEntityWrapper folderWrapper;

  const FolderState(this.folderWrapper);

  @override
  List<Object?> get props => [folderWrapper];
}

/// The initial cubit state.
final class FolderInitial extends FolderState {
  /// Creates a new instance of [FolderInitial].
  const FolderInitial(super.folderWrapper);
}

/// The state when the folder is updated successfully.
final class FolderUpdateSuccess extends FolderState {
  /// Creates a new instance of [FolderUpdateSuccess].
  const FolderUpdateSuccess(super.folderWrapper);
}
