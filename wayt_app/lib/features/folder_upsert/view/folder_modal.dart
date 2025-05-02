import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../util/util.dart';
import '../../../widgets/snack_bar/snack_bar.dart';
import '../../features.dart';
import '../bloc/upsert_folder/upsert_folder_cubit.dart';

/// A modal for adding or editing a folder.
class FolderModal extends StatelessWidget {
  /// Creates a new instance of [FolderModal].
  const FolderModal._({required this.folder});

  /// The folder to update.
  ///
  /// If null it means we're in create mode. i.e., a new folder will be created.
  final WidgetFolderEntity? folder;

  bool get _isEditing => folder != null;

  /// Pushes the modal to the navigator.
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    WidgetFolderEntity? folder,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
          create: (context) => UpsertFolderCubit(
            travelDocumentId: travelDocumentId,
            index: index,
            travelItemRepository: $.repo.travelItem(),
            folderToUpdate: folder,
          ),
          child: FolderModal._(folder: folder),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (Form.maybeOf(context)?.validate() != true) {
      return;
    }
    final result = context.read<UpsertFolderCubit>().validate(context);

    if (!result.isValid) {
      SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: 'Please check the input fields',
      );
    } else {
      await context.navRoot
          .pushBlocListenerBarrier<UpsertFolderCubit, UpsertFolderState>(
        bloc: context.read<UpsertFolderCubit>(),
        trigger: () => context.read<UpsertFolderCubit>().submit(),
        listener: (context, state) {
          if (state.status == StateStatus.success) {
            context.navRoot
              ..pop()
              ..pop();
          } else if (state.status == StateStatus.failure) {
            SnackBarHelper.I.showError(
              context: context,
              message: state.error!.userIntlMessage(context),
            );
            context.pop();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              // FIXME: l10n
              '${!_isEditing ? 'New' : 'Edit'} folder',
            ),
          ),
          body: CustomScrollView(
            slivers: [
              const _FormBody(),
              getScrollableBottomPadding(context).asVSpan.asSliver,
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _submit(context),
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertFolderCubit, UpsertFolderState, String?>(
          selector: (state) => state.name,
          builder: (context, name) => SliverPadding(
            padding: $insets.screenH.asPaddingH,
            sliver: TextFormField(
              initialValue: name,
              onChanged: (value) =>
                  context.read<UpsertFolderCubit>().updateName(value),
              validator: WidgetFolderEntity.getNameValidator(context)
                  .formFieldValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                // FIXME: l10n
                labelText: 'Name',
              ),
            ).asSliver,
          ),
        ),
        $insets.xs.asVSpan.asSliver,
        BlocSelector<UpsertFolderCubit, UpsertFolderState, WidgetFolderIcon?>(
          selector: (state) => state.icon,
          builder: (context, icon) => ListTile(
            // TODO: Create a custom icon picker as this one is pretty ugly
            onTap: () => showIconPicker(
              context,
              configuration: SinglePickerConfiguration(
                // FIXME: l10n
                title: const Text('Pick an icon'),
                // FIXME: l10n
                searchHintText: 'Search icon',
                preSelected: icon != null
                    ? IconPickerIcon(
                        data: icon,
                        name: '',
                        pack: IconPack.material,
                      )
                    : null,
                adaptiveDialog: true,
                constraints: const BoxConstraints.expand(),
                // FIXME: l10n
                noResultsText: 'No results for:',
              ),
            ).then(
              (icon) => context.mounted && icon?.data != null
                  ? context
                      .read<UpsertFolderCubit>()
                      .updateIcon(WidgetFolderIcon.fromIconData(icon!.data))
                  : null,
            ),
            title: const Text('Icon'),
            subtitle: const Text('Choose an icon for the folder'),
            leading: Icon(icon ?? Icons.folder),
          ).asSliver,
        ),
        BlocSelector<UpsertFolderCubit, UpsertFolderState, FeatureColor?>(
          selector: (state) => state.color,
          builder: (context, color) => ListTile(
            onTap: () => FeatureColorPicker.show(context).then(
              (color) => context.mounted && color != null
                  ? context.read<UpsertFolderCubit>().updateColor(color)
                  : null,
            ),
            title: const Text('Color'),
            subtitle: const Text('Choose a color for the folder'),
            leading: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color?.toFlutterColor(context) ??
                    context.theme.colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
            ),
          ).asSliver,
        ),
      ],
    );
  }
}
