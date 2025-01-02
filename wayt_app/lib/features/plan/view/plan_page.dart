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
import '../bloc/fetch_plan/fetch_plan_cubit.dart';
import 'plan_page_body.dart';

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
            create: (context) => FetchPlanCubit(
              planRepository: $.repo.plan(),
              widgetRepository: $.repo.widget(),
              travelItemRepository: $.repo.travelItem(),
              planId: state.pathParameters['planId']!,
            )..fetch(force: false),
            child: PlanView(
              planId: state.pathParameters['planId']!,
              planSummary: state.extra as PlanSummaryEntity?,
            ),
          ),
        ),
      );

  static void go(
    BuildContext context, {
    required String planId,
    required PlanSummaryEntity? planSummary,
  }) =>
      context.router.go('/plans/$planId', extra: planSummary);

  static void push(
    BuildContext context, {
    required String planId,
    required PlanSummaryEntity? planSummary,
  }) =>
      context.router.push('/plans/$planId', extra: planSummary);
}

class PlanView extends StatelessWidget {
  final String planId;
  final PlanSummaryEntity? planSummary;

  const PlanView({
    required this.planId,
    required this.planSummary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPlanCubit, FetchPlanState>(
      builder: (context, state) {
        late final Widget content;
        if (state.status.isSuccess) {
          content = SliverMainAxisGroup(
            slivers: [
              PlanPageBody(
                plan: state.response!.plan,
                travelItems: state.response!.travelItems,
              ),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          );
        } else if (state.status.isFailure) {
          content = Center(
            child: Text(state.error!.userIntlMessage(context)),
          ).asSliver;
        } else {
          content = const SliverFillRemaining(
            child: LoadingIndicatorMessage(),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => AddWidgetMbs.show(
              context,
              id: PlanOrJournalId.plan(planId),
            ),
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text(
                  state.response?.plan.name ?? planSummary?.name ?? '',
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
              content,
            ],
          ),
        );
      },
    );
  }
}
