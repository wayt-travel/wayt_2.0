import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../features.dart';
import '../bloc/folder/folder_cubit.dart';

/// The page for displaying a folder of a plan or journal.
class FolderPage {
  /// The path for displaying a folder of a plan.
  static const planPath = '/plans/:planId/folders/:folderId';

  /// The path for displaying a folder of a journal.
  static const journalPath = '/journals/:journalId/folders/:folderId';

  /// Routes added to the GoRouter.
  static final routes = [
    _getRoute(true),
    _getRoute(false),
  ];

  static GoRoute _getRoute(bool isPlan) => GoRoute(
        path: planPath,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => FolderCubit(
              folderId: state.pathParameters['folderId']!,
              travelItemRepository: $.repo.travelItem(),
            ),
            child: FolderView(
              travelDocumentId: isPlan
                  ? TravelDocumentId.plan(state.pathParameters['planId']!)
                  : TravelDocumentId.journal(
                      state.pathParameters['journalId']!,
                    ),
              folderId: state.pathParameters['folderId']!,
            ),
          ),
        ),
      );

  /// Pushes the [FolderPage] onto the navigation stack.
  static void push(
    BuildContext context, {
    required TravelDocumentId travelDocumentId,
    required String folderId,
  }) =>
      context.router.push(
        Uri.parse(
          (travelDocumentId.isJournal
                  ? journalPath.replaceFirst(':journalId', travelDocumentId.id)
                  : planPath.replaceFirst(':planId', travelDocumentId.id))
              .replaceFirst(':folderId', folderId),
        ).toString(),
      );
}

/// The view of a folder screen.
class FolderView extends StatelessWidget {
  final TravelDocumentId travelDocumentId;
  final String folderId;

  const FolderView({
    required this.travelDocumentId,
    required this.folderId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddWidgetMbs.show(
          context,
          id: travelDocumentId,
          folderId: folderId,
          // Index=null adds the widget at the end of the list.
          index: null,
        ),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: BlocSelector<FolderCubit, FolderState, WidgetFolderEntity>(
              selector: (state) => state.folderWrapper.value,
              builder: (context, folder) {
                return Row(
                  children: [
                    Icon(
                      folder.icon,
                      color: folder.color.toFlutterColor(context),
                    ),
                    $.style.insets.sm.asHSpan,
                    Text(
                      folder.name,
                      style: TextStyle(
                        color: folder.color.toFlutterColor(context),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
          BlocSelector<FolderCubit, FolderState, List<TravelItemEntity>>(
            selector: (state) => state.folderWrapper.children,
            builder: (context, items) => PlanItemList(
              travelItems: items
                  .map((e) => TravelItemEntityWrapper.widget(e.asWidget))
                  .toList(),
            ),
          ),
          getScrollableBottomPadding(context, hasFab: true).asVSpan.asSliver,
        ],
      ),
    );
  }
}
