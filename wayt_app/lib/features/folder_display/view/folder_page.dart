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
        pageBuilder: (context, state) {
          final tid = isPlan
              ? TravelDocumentId.plan(state.pathParameters['planId']!)
              : TravelDocumentId.journal(
                  state.pathParameters['journalId']!,
                );
          final folderId = state.pathParameters['folderId']!;
          return MaterialPage(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => FolderCubit(
                    folderId: folderId,
                    travelItemRepository: $.repo.travelItem(),
                  ),
                ),
                BlocProvider(
                  create: (_) => ReorderItemsCubit(
                    travelDocumentId: tid,
                    folderId: folderId,
                    travelItemRepository: $.repo.travelItem(),
                  ),
                ),
              ],
              child: FolderView(
                travelDocumentId: tid,
                folderId: folderId,
              ),
            ),
          );
        },
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
  /// The ID of the travel document.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder.
  final String folderId;

  /// Creates a new instance of [FolderView].
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
                    $insets.sm.asHSpan,
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
              const TravelDocumentReorderIconButton(),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => FolderModal.show(
                  context: context,
                  travelDocumentId: travelDocumentId,
                  index: null,
                  folder: context.read<FolderCubit>().state.folderWrapper.value,
                ),
              ),
            ],
          ),
          BlocSelector<FolderCubit, FolderState, List<TravelItemEntity>>(
            selector: (state) => state.folderWrapper.children,
            builder: (context, items) => PlanItemList(
              // Force the rebuild of the widget when the list of travel items
              // changes.
              key: ValueKey(items),
              folderId: folderId,
              travelDocumentId: travelDocumentId,
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
