import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../widgets/message/loading_indicator_message.dart';
import '../../widget_upsert/view/modal/add_widget_mbs.dart';
import '../plan.dart';

/// Page for displaying a plan.
class PlanPage {
  /// The name of the route.
  static const String routeName = 'plan';

  /// The path of the route.
  static const String path = '/plans/:planId';

  /// The route of this page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TravelDocumentCubit(
                  travelDocumentRepository: $.repo.travelDocument(),
                  travelItemRepository: $.repo.travelItem(),
                  summaryHelperRepository: $.repo.summaryHelper(),
                  travelDocumentId: TravelDocumentId.plan(
                    state.pathParameters['planId']!,
                  ),
                )..fetch(force: false),
              ),
              BlocProvider(
                create: (context) => ReorderItemsCubit(
                  travelDocumentId: TravelDocumentId.plan(
                    state.pathParameters['planId']!,
                  ),
                  travelItemRepository: $.repo.travelItem(),
                  folderId: null,
                ),
              ),
            ],
            child: PlanView(
              planId: state.pathParameters['planId']!,
              planSummary: state.extra as PlanEntity?,
            ),
          ),
        ),
      );

  /// Navigates to the plan page.
  static void go(
    BuildContext context, {
    required String planId,
    required PlanEntity? planSummary,
  }) =>
      context.router.go('/plans/$planId', extra: planSummary);

  /// Pushes the plan page onto the navigation stack.
  static void push(
    BuildContext context, {
    required String planId,
    required PlanEntity? planSummary,
  }) =>
      context.router.push('/plans/$planId', extra: planSummary);
}

/// The main view of the plan page.
class PlanView extends StatelessWidget {
  /// The id of the plan.
  final String planId;

  /// The summary of the plan.
  ///
  /// This is used to display the name of the plan while the plan is being
  /// fetched.
  ///
  /// If `null`, the name of the plan is not displayed while the full plan is
  /// being fetched.
  final PlanEntity? planSummary;

  /// Creates a new instance of [PlanView].
  const PlanView({
    required this.planId,
    required this.planSummary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelDocumentCubit, TravelDocumentState>(
      buildWhen: (previous, current) => current is TravelDocumentFetchState,
      builder: (context, state) {
        assert(state is TravelDocumentFetchState, 'Invalid state: $state');
        late final Widget content;
        var isSuccess = false;
        PlanEntity? fetchedPlan;
        if (state is TravelDocumentFetchSuccess) {
          isSuccess = true;
          fetchedPlan = state.wrapper.travelDocument.asPlan;
          content = SliverMainAxisGroup(
            slivers: [
              BlocSelector<TravelDocumentCubit, TravelDocumentState,
                  List<TravelItemEntityWrapper>>(
                selector: (state) => state is TravelDocumentStateWithData
                    ? state.wrapper.travelItems
                    : [],
                builder: (context, travelItems) => PlanItemList(
                  // Use a key to force the widget to rebuild when the list
                  // of travel items changes.
                  key: ValueKey(travelItems),
                  folderId: null,
                  travelDocumentId: TravelDocumentId.plan(planId),
                  travelItems: travelItems,
                ),
              ),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          );
        } else if (state is TravelDocumentFetchFailure) {
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
                    id: TravelDocumentId.plan(planId),
                    // folderId=null adds the widget in the root of the travel
                    // document.
                    folderId: null,
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
                        const TravelDocumentReorderIconButton(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => PlanPageMoreMbs.show(context),
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
