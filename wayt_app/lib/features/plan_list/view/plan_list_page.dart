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

class PlanListPage extends StatelessWidget {
  const PlanListPage._();

  static const String routeName = 'plans';
  static const String path = '/$routeName';

  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: PlanListPage._(),
        ),
      );

  static void go(BuildContext context) => context.router.goNamed(routeName);
  static void push(BuildContext context) => context.router.pushNamed(routeName);

  @override
  Widget build(BuildContext context) {
    return const PlanListView();
  }
}

class PlanListView extends StatelessWidget {
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
