import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luthor/luthor.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/snack_bar/snack_bar_helper.dart';
import '../../bloc/add_edit_text_widget/add_edit_text_widget_cubit.dart';
import 'text_widget_modal_bottom_bar.dart';

/// Modal for adding or editing a text widget.
class TextWidgetModal extends StatelessWidget {
  const TextWidgetModal({super.key});

  /// Path for adding a text widget to a plan.
  static const planPathAdd = '/plans/:planId/widgets/text/add';

  /// Path for adding a text widget to a journal.
  static const journalPathAdd = '/journals/:journalId/widgets/text/add';

  /// Routes added to the GoRouter.
  static final routes = [planAddRoute, journalAddRoute];

  /// Route for adding a text widget to a plan.
  static GoRoute get planAddRoute => GoRoute(
        path: planPathAdd,
        pageBuilder: (context, state) => MaterialPage(
          fullscreenDialog: true,
          child: BlocProvider(
            create: (context) => AddEditTextWidgetCubit(
              id: PlanOrJournalId.plan(state.pathParameters['planId']!),
              index: int.tryParse(state.uri.queryParameters['index'] ?? ''),
              text: null,
              textScale: state.uri.queryParameters['format'] != null
                  ? FeatureTextStyleScale.fromName(
                      state.uri.queryParameters['format']!,
                    )
                  : FeatureTextStyleScale.body,
              widgetRepository: $.repo.widget(),
            ),
            child: const TextWidgetModal(),
          ),
        ),
      );

  /// Route for adding a text widget to a journal.
  static GoRoute get journalAddRoute => GoRoute(
        path: journalPathAdd,
        pageBuilder: (context, state) => MaterialPage(
          fullscreenDialog: true,
          child: BlocProvider(
            create: (context) => AddEditTextWidgetCubit(
              id: PlanOrJournalId.journal(state.pathParameters['journalId']!),
              index: int.tryParse(state.uri.queryParameters['index'] ?? ''),
              text: null,
              textScale: state.uri.queryParameters['format'] != null
                  ? FeatureTextStyleScale.fromName(
                      state.uri.queryParameters['format']!,
                    )
                  : FeatureTextStyleScale.body,
              widgetRepository: $.repo.widget(),
            ),
            child: const TextWidgetModal(),
          ),
        ),
      );

  /// Pushes the modal to the navigator.
  static void show({
    required BuildContext context,
    required PlanOrJournalId id,
    required int? index,
    FeatureTextStyleScale? style,
  }) {
    context.router.push(
      Uri.parse(
        id.isJournal
            ? journalPathAdd.replaceFirst(':journalId', id.journalId!)
            : planPathAdd.replaceFirst(':planId', id.planId!),
      ).replace(
        queryParameters: {
          if (index != null) 'index': index.toString(),
          if (style != null) 'format': style.name,
        },
      ).toString(),
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
        child: BlocBuilder<AddEditTextWidgetCubit, AddEditTextWidgetState>(
          builder: (context, state) {
            return TextFormField(
              initialValue: state.text,
              style: state.featureTextStyle.toFlutterTextStyle(context),
              onChanged: (changed) {
                context.read<AddEditTextWidgetCubit>().updateText(changed);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const TextWidgetModalBottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              context.read<AddEditTextWidgetCubit>().validate(context);

          if (!result.isValid) {
            SnackBarHelper.I.showWarning(
              context: context,
              message: (result as SingleValidationError).errors.first,
            );
          } else {
            await context.navRoot.pushBlocListenerBarrier<
                AddEditTextWidgetCubit, AddEditTextWidgetState>(
              bloc: context.read<AddEditTextWidgetCubit>(),
              trigger: () => context.read<AddEditTextWidgetCubit>().submit(),
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
