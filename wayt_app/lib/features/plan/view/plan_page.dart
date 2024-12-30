import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
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
              planId: state.pathParameters['planId']!,
            )..fetch(force: false),
            child: PlanView(
              state.pathParameters['planId']!,
            ),
          ),
        ),
      );

  static void go(
    BuildContext context, {
    required String planId,
  }) =>
      context.router.go('/plans/$planId');

  static void push(
    BuildContext context, {
    required String planId,
  }) =>
      context.router.push('/plans/$planId');
}

class PlanView extends StatelessWidget {
  final String planId;

  const PlanView(this.planId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPlanCubit, FetchPlanState>(
      builder: (context, state) {
        if (state.status.isSuccess) {
          return PlanPageBody(plan: state.plan!);
        } else if (state.status.isFailure) {
          return Center(
            child: Text(state.error!.userIntlMessage(context)),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
