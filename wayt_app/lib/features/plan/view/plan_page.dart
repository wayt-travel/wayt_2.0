import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../widgets/message/loading_indicator_message.dart';
import '../../add_edit_widget/view/add_widget_mbs.dart';
import '../plan.dart';

class PlanPage {
  const PlanPage._();

  static const String routeName = 'plan';
  static const String path = '/plans/:planId';

  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => PlanCubit(
              planRepository: $.repo.plan(),
              widgetRepository: $.repo.widget(),
              travelItemRepository: $.repo.travelItem(),
              summaryHelperRepository: $.repo.summaryHelper(),
              planId: state.pathParameters['planId']!,
            )..fetch(force: false),
            child: PlanView(
              planId: state.pathParameters['planId']!,
              planSummary: state.extra as PlanEntity?,
            ),
          ),
        ),
      );

  static void go(
    BuildContext context, {
    required String planId,
    required PlanEntity? planSummary,
  }) =>
      context.router.go('/plans/$planId', extra: planSummary);

  static void push(
    BuildContext context, {
    required String planId,
    required PlanEntity? planSummary,
  }) =>
      context.router.push('/plans/$planId', extra: planSummary);
}

class PlanView extends StatelessWidget {
  final String planId;
  final PlanEntity? planSummary;

  const PlanView({
    required this.planId,
    required this.planSummary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCubit, PlanState>(
      buildWhen: (previous, current) => current is PlanFetchState,
      builder: (context, state) {
        assert(state is PlanFetchState, 'Invalid state: $state');
        late final Widget content;
        var isSuccess = false;
        PlanEntity? fetchedPlan;
        if (state is PlanFetchSuccess) {
          isSuccess = true;
          fetchedPlan = state.plan;
          content = SliverMainAxisGroup(
            slivers: [
              BlocBuilder<PlanCubit, PlanState>(
                buildWhen: (previous, current) =>
                    current is PlanItemListUpdateSuccess,
                builder: (context, state) {
                  if (state is PlanStateWithData) {
                    return PlanItemList(
                      plan: state.plan,
                      travelItems: state.travelItems,
                    );
                  }

                  throw ArgumentError.value(
                    state,
                    'state',
                    'Invalid state: $state. Expected $PlanStateWithData',
                  );
                },
              ),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          );
        } else if (state is PlanFetchFailure) {
          content = Center(
            child: Text(state.error.userIntlMessage(context)),
          ).asSliver;
        } else {
          content = const SliverFillRemaining(
            child: LoadingIndicatorMessage(),
          );
        }
        return Scaffold(
          // Show the floating action button only when the plan has been fetched
          // successfully.
          floatingActionButton: isSuccess
              ? FloatingActionButton(
                  onPressed: () => AddWidgetMbs.show(
                    context,
                    id: PlanOrJournalId.plan(planId),
                    // Index=null adds the widget at the end of the list.
                    index: null,
                  ),
                  child: const Icon(Icons.add),
                )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text(
                  fetchedPlan?.name ?? planSummary?.name ?? '',
                ),
                actions: isSuccess
                    ? [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ]
                    : null,
              ),
              content,
            ],
          ),
        );
      },
    );
  }
}
