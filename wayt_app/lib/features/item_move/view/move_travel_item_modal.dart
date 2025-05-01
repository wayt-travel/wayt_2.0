import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../item_move.dart';

/// {@template move_travel_item_modal}
/// A modal that allows the user to move travel items to a different folder
/// or to the root of a travel document.
/// {@endtemplate}
class MoveTravelItemModal extends StatefulWidget {
  /// The list of folder of the travel document.
  final List<WidgetFolderEntity> folders;

  /// The id of the folder where the travel items are currently located.
  final String? sourceFolderId;

  /// {@macro move_travel_item_modal}
  const MoveTravelItemModal({
    required this.folders,
    required this.sourceFolderId,
    super.key,
  });

  /// {@macro move_travel_item_modal}
  ///
  /// [travelItemsToMove] is the list of travel items to move.
  ///
  /// [travelDocumentId] is the id of the travel document.
  ///
  /// [sourceFolderId] is the id of the folder where the travel
  /// items are currently located. Null if the travel items are in the root
  /// of the travel document.
  static void show({
    required BuildContext context,
    required List<TravelItemEntity> travelItemsToMove,
    required TravelDocumentId travelDocumentId,
    required String? sourceFolderId,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => MoveTravelItemCubit(
            // Start with the root as default destination folder
            initialDestinationFolderId: null,
            travelDocumentId: travelDocumentId,
            travelItemsToMove: travelItemsToMove,
            travelDocumentLocalMediaDataSource:
                TravelDocumentLocalMediaDataSource.I,
            travelItemRepository: $.repo.travelItem(),
          ),
          child: MoveTravelItemModal(
            sourceFolderId: sourceFolderId,
            folders: $.repo
                .travelItem()
                .getAllOf(travelDocumentId)
                .where((w) => w.isFolderWidget)
                .map((w) => w.asFolderWidgetWrapper.value)
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  State<MoveTravelItemModal> createState() => _MoveTravelItemModalState();
}

class _MoveTravelItemModalState extends State<MoveTravelItemModal> {
  final _nestedNavigatorKey = GlobalKey<NavigatorState>();

  void _pushFolder(
    BuildContext context,
    WidgetFolderEntity folder,
  ) {
    context.read<MoveTravelItemCubit>().changeDestinationFolderId(folder.id);
    _nestedNavigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                context
                    .read<MoveTravelItemCubit>()
                    .changeDestinationFolderId(null);
                context.nav.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(folder.name),
          ),
          body: Center(
            child: BlocBuilder<MoveTravelItemCubit, MoveTravelItemState>(
              builder: (context, state) {
                final isSameFolder =
                    state.destinationFolderId == widget.sourceFolderId;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSameFolder
                          ? Icons.thumb_up
                          : Icons.drive_folder_upload_rounded,
                      size: 80,
                    ),
                    $insets.sm.asVSpan,
                    Text(
                      isSameFolder
                          ? 'The widgets are already in this folder'
                          : 'The widgets will be moved to this folder',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  MaterialPageRoute<void> _buildRoot(BuildContext context) => MaterialPageRoute(
        builder: (context) => ListView.builder(
          itemCount: widget.folders.length,
          itemBuilder: (context, index) {
            final folder = widget.folders[index];
            return ListTile(
              leading: Icon(
                folder.icon,
                color: folder.color.toFlutterColor(context),
              ),
              title: Text(
                folder.name,
                style: TextStyle(
                  color: folder.color.toFlutterColor(context),
                ),
              ),
              onTap: () => _pushFolder(context, folder),
              trailing: Icon(
                Icons.arrow_forward,
                color: folder.color.toFlutterColor(context),
              ),
            );
          },
        ),
      );

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<MoveTravelItemCubit>();
    await context.navRoot
        .pushBlocListenerBarrier<MoveTravelItemCubit, MoveTravelItemState>(
      bloc: cubit,
      trigger: cubit.submit,
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.navRoot
            ..pop()
            ..pop();
        } else if (state.status.isFailure) {
          context.navRoot.pop();
          SnackBarHelper.I.showFromWError(
            context: context,
            error: state.error!,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoveTravelItemCubit, MoveTravelItemState>(
      builder: (context, state) {
        final isRoot = state.destinationFolderId == null;
        final isSameFolder = state.destinationFolderId == widget.sourceFolderId;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Move widgets'),
          ),
          body: Column(
            children: [
              Padding(
                padding: $insets.screenH.asPadding,
                child: const Text(
                  // FIXME: l10n
                  'Select a folder where to move the widgets or tap the button '
                  'on the bottom to move them to the document root',
                ),
              ),
              Expanded(
                child: Navigator(
                  key: _nestedNavigatorKey,
                  onGenerateRoute: (settings) => _buildRoot(context),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: FilledButton.icon(
              onPressed: isSameFolder ? null : () => _submit(context),
              label: Text(
                (isSameFolder
                        ? 'Items are already here'
                        : isRoot
                            ? 'Move here'
                            : 'Move to this folder')
                    .toUpperCase(),
              ),
              icon: isSameFolder
                  ? null
                  : const Icon(Icons.drive_folder_upload_rounded),
            ),
          ),
        );
      },
    );
  }
}
