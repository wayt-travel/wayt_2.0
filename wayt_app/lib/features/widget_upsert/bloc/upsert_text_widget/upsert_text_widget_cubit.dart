import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/context/context.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';

part 'upsert_text_widget_state.dart';

/// Cubit for adding or editing a text widget.
class UpsertTextWidgetCubit extends Cubit<UpsertTextWidgetState>
    with LoggerMixin {
  /// The id of the plan or journal where the widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The id of the folder where the widget will be added.
  ///
  /// Null if the widget is being added to the root of the travel document.
  final String? folderId;

  /// The index where the widget will be added.
  ///
  /// Null if the widget is being edited (as the index is not needed) or if the
  /// widget is being added at the end of the list.
  final int? index;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// {@template text_widget_to_update}
  /// The text widget to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new text widget will be
  /// created.
  /// {@endtemplate}
  final TextWidgetModel? textWidgetToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => textWidgetToUpdate != null;

  /// Creates an upsert text widget cubit.
  UpsertTextWidgetCubit({
    required TypographyFeatureScale textScale,
    required this.index,
    required this.travelDocumentId,
    required this.folderId,
    required this.travelItemRepository,
    this.textWidgetToUpdate,
  }) : super(
          UpsertTextWidgetState.initial(
            featureTextStyle: textWidgetToUpdate?.textStyle ??
                TypographyFeatureStyle(
                  scale: textScale,
                ),
            text: textWidgetToUpdate?.text,
          ),
        );

  /// Updates the text of the widget.
  void updateText(String text) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        text: Optional(text.trim()),
      ),
    );
  }

  /// Updates the text style of the widget.
  void updateTextStyle(TypographyFeatureStyle textStyle) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        featureTextStyle: textStyle,
      ),
    );
  }

  /// Validates the current state of the cubit.
  SingleValidationResult<dynamic> validate(BuildContext? context) {
    return Validators.l10n(context)
        .textInfiniteRequired()
        .validateValue(state.text?.trim());
  }

  /// Submits the text widget addition or modification based on the cubit state.
  Future<void> submit() async {
    logger.d(
      '${!isUpdate ? 'Submitting' : 'Updating'} text widget in '
      '$travelDocumentId and folderId=$folderId...',
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
    late final WTaskEither<void> task;
    if (!isUpdate) {
      task = travelItemRepository.createWidget(
        widget: TextWidgetModel(
          id: const Uuid().v4(),
          text: state.text!.trim(),
          textStyle: state.featureTextStyle,
          travelDocumentId: travelDocumentId,
          folderId: folderId,
          // The order is neglected at creation time.
          order: -1,
        ),
        index: index,
      );
    } else {
      task = travelItemRepository.updateWidget(
        widget: textWidgetToUpdate!.copyWith(
          text: state.text!.trim(),
          textStyle: state.featureTextStyle,
        ),
      );
    }

    (await task.run()).fold(
      (error) {
        logger.e('Error upserting text widget: $error');
        emit(state.copyWithError(error));
      },
      (_) {
        logger.d('Text widget upserted successfully');
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
}
