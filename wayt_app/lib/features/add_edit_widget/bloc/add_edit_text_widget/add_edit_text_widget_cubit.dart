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

part 'add_edit_text_widget_state.dart';

class AddEditTextWidgetCubit extends Cubit<AddEditTextWidgetState>
    with LoggerMixin {
  final PlanOrJournalId id;
  final WidgetRepository widgetRepository;

  AddEditTextWidgetCubit({
    required FeatureTextStyleScale textScale,
    required String? text,
    required this.id,
    required this.widgetRepository,
  }) : super(
          AddEditTextWidgetState.initial(
            featureTextStyle: FeatureTextStyle(scale: textScale),
            text: text,
          ),
        );

  void updateText(String text) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        text: Optional(text),
      ),
    );
  }

  void updateTextStyle(FeatureTextStyle textStyle) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        featureTextStyle: textStyle,
      ),
    );
  }

  SingleValidationResult<dynamic> validate(BuildContext? context) {
    return L10nValidators.text1ToInf(context).validateValue(state.text);
  }

  Future<void> submit() async {
    logger.v('Submitting text widget in $id');
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

    try {
      await widgetRepository.create(
        TextWidgetModel(
          id: const Uuid().v4(),
          text: state.text!,
          textStyle: state.featureTextStyle,
          planOrJournalId: id,
        ),
      );
      logger.i('Text widget created successfully.');
      emit(state.copyWith(status: StateStatus.success));
    } catch (e, s) {
      logger.e('Error creating text widget: $e', e, s);
      emit(state.copyWithError(e.errorOrGeneric));
      return;
    }
  }
}
