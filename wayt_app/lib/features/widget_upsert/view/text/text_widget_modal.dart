import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luthor/luthor.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/snack_bar/snack_bar_helper.dart';
import '../../bloc/upsert_text_widget/upsert_text_widget_cubit.dart';
import 'text_widget_modal_bottom_bar.dart';

/// Modal for adding or editing a text widget.
class TextWidgetModal extends StatelessWidget {
  const TextWidgetModal({super.key});

  /// Pushes the modal to the navigator.
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    required String? folderId,
    required FeatureTextStyleScale textScale,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => UpsertTextWidgetCubit(
            travelDocumentId: travelDocumentId,
            index: index,
            text: null,
            textScale: textScale,
            folderId: folderId,
            travelItemRepository: $.repo.travelItem(),
          ),
          child: const TextWidgetModal(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // FIXME: l10n
          'Add text widget',
        ),
      ),
      body: Form(
        child: BlocBuilder<UpsertTextWidgetCubit, UpsertTextWidgetState>(
          builder: (context, state) {
            return TextFormField(
              initialValue: state.text,
              style: state.featureTextStyle.toFlutterTextStyle(context),
              onChanged: (changed) {
                context.read<UpsertTextWidgetCubit>().updateText(changed);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const TextWidgetModalBottomBar(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
