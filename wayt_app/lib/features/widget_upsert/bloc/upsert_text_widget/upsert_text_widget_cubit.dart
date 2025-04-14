import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/context/context.dart';
import '../../../../error/errors.dart';
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

  /// Creates an upsert text widget cubit.
  UpsertTextWidgetCubit({
    required TypographyFeatureScale textScale,
    required String? text,
    required this.index,
    required this.travelDocumentId,
    required this.folderId,
    required this.travelItemRepository,
  }) : super(
          UpsertTextWidgetState.initial(
            featureTextStyle: TypographyFeatureStyle(scale: textScale),
            text: text,
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
    logger.v(
      'Submitting text widget in $travelDocumentId and folderId=$folderId...',
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

    final either = await travelItemRepository.addSequentialAndWait<void>(
      TravelItemRepoWidgetCreatedEvent(
        (
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
        ),
      ),
    );

    either.fold(
      (error) {
        logger.e('Error creating text widget: $error');
        emit(state.copyWithError(error));
      },
      (_) {
        logger.d('Text widget created successfully');
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
}
