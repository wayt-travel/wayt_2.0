import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../repositories/repositories.dart';

part 'folder_state.dart';

/// The cubit for the folder display.
class FolderCubit extends Cubit<FolderState> {
  /// The id of the folder.
  final String folderId;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The subscription to the travel item repository.
  StreamSubscription<TravelItemRepositoryState>? _travelItemRepoSub;

  /// Creates a new instance of [FolderCubit].
  FolderCubit({
    required this.folderId,
    required this.travelItemRepository,
  }) : super(
          FolderInitial(
            travelItemRepository
                .getWrappedOrThrow(folderId)
                .asFolderWidgetWrapper,
          ),
        ) {
    _travelItemRepoSub = travelItemRepository.listen((repoState) {
      if (isClosed) return;
      // Case A: a widget contained in the current folder is deleted
      final widgetDeleted = repoState is TravelItemRepoItemDeleteSuccess &&
          repoState.itemWrapper.isWidget &&
          repoState.itemWrapper.asWidgetWrapper.value.folderId == folderId;

      // Case B: a widget is created in the current folder
      final widgetCreated = repoState is TravelItemRepoItemCreateSuccess &&
          repoState.itemWrapper.isWidget &&
          repoState.itemWrapper.asWidgetWrapper.value.folderId == folderId;

      // Case C: the travel document items are fetched
      final collectionFetched =
          repoState is TravelItemRepoItemCollectionFetchSuccess;

      final shouldEmit = widgetDeleted || widgetCreated || collectionFetched;
      if (shouldEmit) {
        emit(
          FolderUpdateSuccess(
            travelItemRepository
                .getWrappedOrThrow(folderId)
                .asFolderWidgetWrapper,
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _travelItemRepoSub?.cancel().ignore();
    return super.close();
  }
}
