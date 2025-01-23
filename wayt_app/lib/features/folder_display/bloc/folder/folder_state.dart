part of 'folder_cubit.dart';

@immutable
sealed class FolderState extends Equatable {
  final WidgetFolderEntityWrapper folderWrapper;

  const FolderState(this.folderWrapper);

  @override
  List<Object?> get props => [folderWrapper];
}

final class FolderInitial extends FolderState {
  const FolderInitial(super.folderWrapper);
}

/// The state when the folder is updated successfully.
final class FolderUpdateSuccess extends FolderState {
  const FolderUpdateSuccess(super.folderWrapper);
}
