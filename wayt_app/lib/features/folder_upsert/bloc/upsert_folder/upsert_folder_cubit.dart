import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../core/context/context.dart';
import '../../../../error/errors.dart';
import '../../../../repositories/repositories.dart';

part 'upsert_folder_state.dart';

/// Cubit for adding or editing a folder.
class UpsertFolderCubit extends Cubit<UpsertFolderState> with LoggerMixin {
  /// The id of the plan or journal where the folder will be added.
  final TravelDocumentId travelDocumentId;

  /// The index where the folder will be added.
  ///
  /// Null if the widget is being edited (as the index is not needed) or if the
  /// widget is being added at the end of the list.
  final int? index;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The folder entity to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new folder will be
  /// created.
  final WidgetFolderEntity? folderToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => folderToUpdate != null;

  /// Creates a new instance of [UpsertFolderCubit].
  UpsertFolderCubit({
    required this.index,
    required this.travelDocumentId,
    required this.travelItemRepository,
    this.folderToUpdate,
  }) : super(UpsertFolderState.initial(folderToUpdate));

  /// Updates the name of the folder.
  void updateName(String? name) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        name: Option.of(name),
      ),
    );
  }

  /// Updates the icon of the folder.
  void updateIcon(WidgetFolderIcon icon) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        icon: icon,
      ),
    );
  }

  /// Updates the color of the folder.
  void updateColor(FeatureColor color) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        color: color,
      ),
    );
  }

  /// Validates the current state of the cubit.
  SingleValidationResult<dynamic> validate(BuildContext? context) {
    return WidgetFolderEntity.getNameValidator(context)
        .validateValue(state.name);
  }

  /// Submits the creation/update of the folder based on the current state.
  Future<void> submit() async {
    logger.v(
      '${!isUpdate ? 'Submitting new folder' : 'Updating folder '
          '$folderToUpdate'} ',
    );
    emit(
      state.copyWith(status: StateStatus.progress),
    );
    if (!validate(null).isValid) {
      logger.wtf(
        'Invalid cubit state $state. It should have been validated before '
        'submitting!!!',
      );
      emit(state.copyWithError($.errors.validation.invalidCubitState));
      return;
    }

    if (!isUpdate) {
        await travelItemRepository.createFolder(
          state.toCreateInput(travelDocumentId, index),
        );
      } else {
        await travelItemRepository.updateFolder(
          folderToUpdate!.id,
          travelDocumentId: travelDocumentId,
          input: state.toUpdateInput(),
        );
      }

    final either =
        await travelItemRepository.addSequentialAndWait<void>(
      TravelItemRepoFolderCreatedEvent(
        (
          color: state.color,
          icon: state.icon,
          name: state.name!,
          travelDocumentId: travelDocumentId,
          index: index,
        ),
      ),
    );
    either.match(
      (error) {
        logger.e('Error creating folder: $error');
        emit(state.copyWithError(error));
      },
      (_) {
        logger.i('Folder created successfully.');
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
}
