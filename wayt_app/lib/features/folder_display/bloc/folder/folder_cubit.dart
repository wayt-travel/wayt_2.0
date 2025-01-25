import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../repositories/repositories.dart';

part 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  final String folderId;

  final TravelItemRepository travelItemRepository;

  StreamSubscription<TravelItemRepositoryState>? _travelItemRepoSub;

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
      if (repoState is TravelItemRepositoryTravelItemUpdated &&
          repoState.updatedItem.isFolderWidget &&
          repoState.updatedItem.value.id == folderId) {
        // Case: the current folder is updated
        emit(
          FolderUpdateSuccess(repoState.updatedItem.asFolderWidgetWrapper),
        );
      } else if (repoState is TravelItemRepositoryTravelItemDeleted &&
          repoState.item.isWidget &&
          repoState.item.asWidgetWrapper.value.folderId == folderId) {
        // Case: a widget contained in the current folder is deleted
        emit(
          FolderUpdateSuccess(
            travelItemRepository
                .getWrappedOrThrow(folderId)
                .asFolderWidgetWrapper,
          ),
        );
      } else if (repoState is TravelItemRepositoryTravelItemAdded &&
          repoState.item.isWidget &&
          repoState.item.asWidgetWrapper.value.folderId == folderId) {
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
