import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/context/context.dart';
import '../../../util/text_style_extension.dart';
import '../../../widgets/widgets.dart';
import '../../widget_display/view/travel_item_widget_context_menu.dart';
import '../bloc/folder/folder_cubit.dart';
import 'folder_page.dart';

/// A widget displaying a folder in a travel document.
class FolderWidget extends StatefulWidget {
  /// The index of the folder in the list of items.
  final int index;

  /// Creates a new instance of [FolderWidget].
  const FolderWidget({
    required this.index,
    super.key,
  });

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) {
        final folder = state.folderWrapper.value;
        return Stack(
          children: [
            InkWell(
              onLongPress: () {
                SnackBarHelper.I.showNotImplemented(context);
              },
              onTapUp: (details) {
                setState(() => _isHovering = true);
                TravelItemWidgetContextMenu.showForItem(
                  context: context,
                  position: details.globalPosition,
                  travelItem: folder,
                  index: widget.index,
                ).then((_) => setState(() => _isHovering = false));
              },
              child: ColoredBox(
                color: _isHovering
                    ? context.col.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
                child: Card.filled(
                  color: folder.color
                      .toFlutterColor(context)
                      .withValues(alpha: 0.4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          folder.icon,
                          color: folder.color.toFlutterColor(context),
                        ),
                        title: Text(folder.name),
                        trailing: IconButton(
                          onPressed: () => FolderPage.push(
                            context,
                            travelDocumentId: folder.travelDocumentId,
                            folderId: folder.id,
                          ),
                          icon: const Icon(Icons.launch),
                        ),
                        contentPadding: $insets.sm.asPaddingLeft,
                      ),
                      $insets.xxs.asVSpan,
                      Padding(
                        padding: $insets.xs.asPaddingBottom,
                        child: Text(
                          // FIXME: l10n
                          'This folder contains '
                          '${state.folderWrapper.children.length} widgets',
                          style: context.tt.labelSmall?.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
