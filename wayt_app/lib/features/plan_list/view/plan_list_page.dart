import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/message/loading_indicator_message.dart';
import '../bloc/fetch_plans/fetch_plans_cubit.dart';
import 'plan_list_body.dart';

/// The page showing the list of plans.
class PlanListPage extends StatelessWidget {
  const PlanListPage._();

  /// The route name of the plan list page.
  static const String routeName = 'plans';

  /// The path of the plan list page.
  static const String path = '/$routeName';

  /// The route of the plan list page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: PlanListPage._(),
        ),
      );

  /// Navigates to the plan list page.
  static void go(BuildContext context) => context.router.goNamed(routeName);

  /// Pushes the plan list page to the navigator.
  static void push(BuildContext context) => context.router.pushNamed(routeName);

  @override
  Widget build(BuildContext context) {
    return const PlanListView();
  }
}

/// The view of the plan list page.
class PlanListView extends StatelessWidget {
  /// Creates a new instance of [PlanListView].
  const PlanListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FetchPlansCubit(planRepository: GetIt.I.get<PlanRepository>())
            ..fetch(),
      child: Builder(
        builder: (_) => BlocBuilder<FetchPlansCubit, FetchPlansState>(
          builder: (context, state) {
            late final Widget content;

            if (state.plans.isNotEmpty) {
              content = PlanListBody(
                key: ValueKey(state.plans),
                state.plans,
              );
            } else if (state.status.isSuccess) {
              content = const Center(
                child: Text('Start crating a new travel plan!'),
              ).asSliver;
            } else if (state.status.isFailure) {
              content = Center(
                child: Text(state.error!.userIntlMessage(context)),
              ).asSliver;
            } else {
              content = const SliverFillRemaining(
                child: Center(
                  child: LoadingIndicatorMessage(),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<FetchPlansCubit>().fetch(),
              // 152 is the height of the SliverAppBar.large
              edgeOffset: 152,
              backgroundColor: context.col.surfaceContainer,
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar.large(title: Text('Plans')),
                  content,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
