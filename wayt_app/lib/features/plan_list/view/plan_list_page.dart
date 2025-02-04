import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../widgets/widgets.dart';
import '../../features.dart';
import 'plan_list_body.dart';

/// The page showing the list of plans.
class PlanListPage {
  const PlanListPage._();

  /// The route name of the plan list page.
  static const String routeName = 'plans';

  /// The path of the plan list page.
  static const String path = '/$routeName';

  /// The route of the plan list page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (context) => PlanListCubit(
              travelDocumentRepository: $.repo.travelDocument(),
              authRepository: $.repo.auth(),
            )..fetch(),
            child: const PlanListView(),
          ),
        ),
      );

  /// Navigates to the plan list page.
  static void go(BuildContext context) => context.router.goNamed(routeName);

  /// Pushes the plan list page to the navigator.
  static void push(BuildContext context) => context.router.pushNamed(routeName);
}

/// The view of the plan list page.
class PlanListView extends StatelessWidget {
  /// Creates a new instance of [PlanListView].
  const PlanListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanListCubit, PlanListState>(
      listener: (context, state) => state.status.isFailure
          ? SnackBarHelper.I.showError(
              context: context,
              message: state.error!.userIntlMessage(context),
            )
          : null,
      builder: (context, state) {
        late final Widget content;
        Widget? fab = FloatingActionButton(
          onPressed: () => UpsertPlanModal.showForCreating(context),
          child: const Icon(Icons.add),
        );

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
          fab = null;
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => context.read<PlanListCubit>().fetch(),
            // 152 is the height of the SliverAppBar.large
            edgeOffset: 152,
            backgroundColor: context.col.surfaceContainer,
            child: CustomScrollView(
              slivers: [
                const SliverAppBar.large(title: Text('Plans')),
                content,
              ],
            ),
          ),
          floatingActionButton: fab,
        );
      },
    );
  }
}
