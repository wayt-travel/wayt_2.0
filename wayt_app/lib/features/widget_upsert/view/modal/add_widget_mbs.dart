import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/pickers/file_picker.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';

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
              $insets.sm.asVSpan.asSliver,
              const AddWidgetMbsSection(
                // FIXME: l10n
                title: 'Most used',
              ),
              AddWidgetMbsSectionCustom(
                // FIXME: l10n
                title: 'Texts',
                sliver: Wrap(
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
              ),
              AddWidgetMbsSection(
                // FIXME: l10n
                title: 'Media',
                startingRandomColorIndex: 4,
                children: [
                  NewItemButton(
                    // FIXME: l10n
                    label: 'Photo',
                    size: size,
                    child: const Icon(Icons.photo, size: 32),
                    onTap: (context) {
                      context.navRoot.pop();
                      PhotoWidgetPickerModal.show(
                        context: context,
                        index: index,
                        folderId: folderId,
                        travelDocumentId: travelDocumentId,
                      );
                    },
                  ),
                  NewItemButton(
                    // FIXME: l10n
                    label: 'File',
                    size: size,
                    onTap: (ctx) async {
                      // ctx is the context of the item button
                      // context is the context of the modal bottom sheet
                      // when the mbs is popped the context is no
                      // longer mounted.
                      // So the mbs should be popped when cubit terminates
                      // its processing.
                      final cubit = CreateFileWidgetCubit(
                        index: index,
                        folderId: folderId,
                        travelDocumentId: travelDocumentId,
                        authRepository: $.repo.auth(),
                        travelItemRepository: $.repo.travelItem(),
                        travelDocumentLocalMediaDataSource:
                            TravelDocumentLocalMediaDataSource.I,
                      );
                      await ctx.navRoot.pushBlocListenerBarrier<
                          CreateFileWidgetCubit, CreateFileWidgetState>(
                        bloc: cubit,
                        trigger: () async {
                          final files = await FilePicker.pick(context);
                          unawaited(cubit.process(files));
                        },
                        listener: (_, state) {
                          // Handle success
                          // Pop the barrier
                          ctx.navRoot.pop();
                          // the mbs
                          context.navRoot.pop();
                          if (state.status.isSuccess) {
                            if (state.errors.isNotEmpty) {
                              SnackBarHelper.I.showError(
                                context: context,
                                // FIXME: l10n
                                message:
                                    'Failed to create ${state.errors.length} '
                                    'of '
                                    '${state.requests.length} file widgets',
                              );
                            }
                          }
                        },
                        listenWhen: (previous, current) =>
                            current.status.isFailure ||
                            current.status.isSuccess,
                      );
                    },
                    child: const Icon(
                      Icons.upload_file,
                      size: 32,
                    ),
                  ),
                ],
              ),
              AddWidgetMbsSection(
                // FIXME: l10n
                title: 'Misc',
                startingRandomColorIndex: 8,
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
                  NewItemButton(
                    // FIXME: l10n
                    label: 'Place',
                    size: size,
                    child: const Icon(Icons.place, size: 32),
                    onTap: (context) {
                      context.navRoot.pop();
                      UpsertPlaceWidgetModal.show(
                        context: context,
                        travelDocumentId: travelDocumentId,
                        index: index,
                        folderId: folderId,
                      );
                    },
                  ),
                  NewItemButton(
                    // FIXME: l10n
                    label: 'Transfer',
                    size: size,
                    child: const Icon(Icons.route, size: 32),
                    onTap: (context) {
                      context.navRoot.pop();
                      UpsertTransferWidgetModal.show(
                        context: context,
                        travelDocumentId: travelDocumentId,
                        index: index,
                        folderId: folderId,
                      );
                    },
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
