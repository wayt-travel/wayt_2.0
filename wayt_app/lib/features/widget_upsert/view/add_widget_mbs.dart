import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../widgets/modal/modal.dart';
import '../../features.dart';
import '../../folder_upsert/view/folder_modal.dart';

/// Modal bottom sheet to add a new widget in a travel document.
class AddWidgetMbs extends StatelessWidget {
  /// The id of the travel document.
  final TravelDocumentId travelDocumentId;

  /// The id of the folder.
  ///
  /// Null if the widget will not be in a folder.
  final String? folderId;

  /// The index where to insert the widget in the items list.
  ///
  /// Null if the widget will be added at the end of the list.
  ///
  /// If the widget is inserted in a folder, the index should be relative to
  /// the folder items.
  final int? index;

  /// The scroll controller to control the scroll position.
  final ScrollController? scrollController;

  /// Creates a new instance of [AddWidgetMbs].
  const AddWidgetMbs({
    required this.travelDocumentId,
    required this.index,
    required this.folderId,
    super.key,
    this.scrollController,
  });

  /// Shows the modal bottom sheet.
  ///
  /// [context] The build context.
  ///
  /// [folderId] The id of the folder. Null if the widget will not be in a
  /// folder.
  ///
  /// [id] The id of the travel document.
  ///
  /// [index] The index where to insert the widget in the items list. Null if
  /// the widget will be added at the end of the list. If the widget is inserted
  /// in a folder, the index should be relative to the folder items.
  static Future<void> show(
    BuildContext context, {
    required String? folderId,
    required TravelDocumentId id,
    required int? index,
  }) =>
      ModalBottomSheet.of(context).showExpanded(
        startExpanded: true,
        builder: (context, scrollController) => SafeArea(
          bottom: false,
          child: AddWidgetMbs(
            scrollController: scrollController,
            folderId: folderId,
            index: index,
            travelDocumentId: id,
          ),
        ),
      );

  List<Widget> _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) =>
      [
        Text(
          title,
          style: context.tt.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).asSliver,
        $insets.xs.asVSpan.asSliver,
        ...children,
        $insets.sm.asVSpan.asSliver,
      ];

  @override
  Widget build(BuildContext context) {
    final size = context.mq.size.width / 6;
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: $insets.screenH.asPaddingH,
          sliver: SliverMainAxisGroup(
            slivers: [
              Text(
                // FIXME: l10n
                'Add widget',
                style: context.tt.titleLarge?.copyWith(
                  fontFamily: kFontFamilySerif,
                ),
              ).asSliver,
              $.style.insets.sm.asVSpan.asSliver,
              ..._buildSection(
                context: context,
                // FIXME: l10n
                title: 'Most used',
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: RandomColor.materialColors
                        .take(4)
                        .map(
                          (color) => SizedBox.square(
                            dimension: size,
                            child: Placeholder(color: color),
                          ),
                        )
                        .toList(),
                  ).asSliver,
                ],
              ),
              ..._buildSection(
                context: context,
                // FIXME: l10n
                title: 'Texts',
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: TypographyFeatureScale.values
                        .map(
                          (scale) => TextWidgetScaleButton(
                            scale: scale,
                            size: size,
                            onTap: (context) {
                              context.navRoot.pop();
                              TextWidgetModal.show(
                                context: context,
                                travelDocumentId: travelDocumentId,
                                index: index,
                                textScale: scale,
                                folderId: folderId,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ).asSliver,
                ],
              ),
              ..._buildSection(
                context: context,
                // FIXME: l10n
                title: 'Misc',
                children: [
                  SliverGrid.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: $insets.md,
                    mainAxisSpacing: $insets.md,
                    children: [
                      if (folderId == null)
                        NewItemButton(
                          // FIXME: l10n
                          label: 'Folder',
                          size: size,
                          child: const Icon(Icons.folder, size: 32),
                          onTap: (context) {
                            context.navRoot.pop();
                            FolderModal.show(
                              context: context,
                              travelDocumentId: travelDocumentId,
                              index: index,
                            );
                          },
                        ),
                      ...RandomColor.materialColors
                          .sublist(4)
                          .take(folderId == null ? 7 : 8)
                          .map(
                            (color) => SizedBox.square(
                              dimension: size,
                              child: Placeholder(color: color),
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
