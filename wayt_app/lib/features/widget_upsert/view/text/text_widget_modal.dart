import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luthor/luthor.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/snack_bar/snack_bar_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/upsert_text_widget/upsert_text_widget_cubit.dart';
import 'text_widget_modal_bottom_bar.dart';

/// Modal for adding or editing a text widget.
class TextWidgetModal extends StatelessWidget {
  /// Creates a new instance of [TextWidgetModal].
  const TextWidgetModal._({required this.textWidget});

  /// {@macro text_widget_to_update}
  final TextWidgetModel? textWidget;

  bool get _isEditing => textWidget != null;

  /// Pushes the modal to the navigator.
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    required String? folderId,
    required TypographyFeatureScale textScale,
    TextWidgetModel? textWidget,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => UpsertTextWidgetCubit(
            travelDocumentId: travelDocumentId,
            index: index,
            textScale: textScale,
            folderId: folderId,
            travelItemRepository: $.repo.travelItem(),
            textWidgetToUpdate: textWidget,
          ),
          child: TextWidgetModal._(textWidget: textWidget),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // FIXME: l10n
          '${!_isEditing ? 'Add' : 'Edit'} text widget',
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: $insets.screenH.asPaddingH.copyWith(bottom: 140),
            child: Form(
              child: BlocBuilder<UpsertTextWidgetCubit, UpsertTextWidgetState>(
                builder: (context, state) {
                  return TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    initialValue: state.text,
                    style: state.featureTextStyle.toFlutterTextStyle(context),
                    onChanged: (changed) {
                      context.read<UpsertTextWidgetCubit>().updateText(changed);
                    },
                  );
                },
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              // Cannot use the bottom bar as a scaffold.bottomBar because it
              // gets hidden by the keyboard.
              child: TextWidgetModalBottomBar(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              context.read<UpsertTextWidgetCubit>().validate(context);

          if (!result.isValid) {
            SnackBarHelper.I.showWarning(
              context: context,
              message: (result as SingleValidationError).errors.first,
            );
          } else {
            await context.navRoot.pushBlocListenerBarrier<UpsertTextWidgetCubit,
                UpsertTextWidgetState>(
              bloc: context.read<UpsertTextWidgetCubit>(),
              trigger: () => context.read<UpsertTextWidgetCubit>().submit(),
              listener: (context, state) {
                if (state.status == StateStatus.success) {
                  context.navRoot
                    ..pop()
                    ..pop();
                } else if (state.status == StateStatus.failure) {
                  SnackBarHelper.I.showError(
                    context: context,
                    message: state.error.toString(),
                  );
                  context.pop();
                }
              },
            );
          }
        },
        child: const Icon(Icons.save),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
