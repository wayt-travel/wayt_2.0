import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/create_photo_widget/create_photo_widget_cubit.dart';

/// Modal for picking photos to create a photo widget.
class PhotoWidgetPickerModal extends StatelessWidget {
  const PhotoWidgetPickerModal._();

  /// Show the modal.
  ///
  /// Upon showing the modal, the cubit will start and prompt the user to pick
  /// photos. Then if the user has selected no photos, the modal will close.
  /// If the user has selected photos, the cubit will start processing them and
  /// the modal will show a progress indicator until the processing is done.
  Future<void> show({
    required BuildContext context,
    required int index,
    required String? folderId,
    required TravelDocumentId travelDocumentId,
  }) =>
      context.navRoot.push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => BlocProvider(
            create: (context) => CreatePhotoWidgetCubit(
              travelDocumentId: travelDocumentId,
              folderId: folderId,
              index: index,
              authRepository: $.repo.auth(),
              travelItemRepository: $.repo.travelItem(),
            )..pick(),
            child: const PhotoWidgetPickerModal._(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePhotoWidgetCubit, CreatePhotoWidgetState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          if (state.errors.isNotEmpty) {
            SnackBarHelper.I.showError(
              context: context,
              // FIXME: l10n
              message: 'Failed to create ${state.errors.length} of '
                  '${state.requests.length} photo widgets',
            );
          }
          // Handle success
          context.nav.pop();
          return;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              // FIXME: l10n
              title: const Text('Add photo widget'),
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: state.processed.length / state.requests.length,
                  ),
                  $style.insets.sm.asVSpan,
                  Text(
                    // FIXME: l10n
                    'Processing photos: ${state.processed.length} / '
                    '${state.requests.length}',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
