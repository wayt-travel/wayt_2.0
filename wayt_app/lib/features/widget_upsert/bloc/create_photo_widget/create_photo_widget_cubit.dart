import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flext/flext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../features.dart';

part 'create_photo_widget_state.dart';

/// {@template create_photo_widget_cubit}
/// Cubit for creating a photo widget.
///
/// This cubit is responsible for picking images from the device and processing
/// them one by one to create a photo widget for each image picked.
///
/// The listener should be implemented so that:
/// - As long as the cubit is in [StateStatus.progress] the user should not
///   interact with the UI.
/// - The user should see the progress of the image processing based on the
///   index of the image being processed and the total number of images.
/// - Single processing errors **are NOT notified** via [StateStatus.failure].
///   The count of errors is available in the state
///   [CreatePhotoWidgetState.errors].
/// - Once the processing is done ([StateStatus.success]), the purpose of this
///   cubit is complete, thus we normally expect the cubit to be closed. E.g.,
///   the modal that was using the cubit is popped.
/// - When the processing is done, do not ever expect [StateStatus.failure], it
///   will always be [StateStatus.success] even though some images may have
///   failed to be processed.
/// - Notify to the user the errors that occurred during processing using the
///   [CreatePhotoWidgetState.errors] list.
/// {@endtemplate}
class CreatePhotoWidgetCubit extends Cubit<CreatePhotoWidgetState>
    with LoggerMixin {
  /// The ID of the travel document where the photo widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder where the photo widget will be added.
  final String? folderId;

  /// The travel item repository.
  final AuthRepository authRepository;

  /// The index where the photo widget will be added.
  ///
  /// If `null`, the photo widget will be added at the end of the list.
  final int? index;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// {@macro create_photo_widget_cubit}
  CreatePhotoWidgetCubit({
    required this.travelDocumentLocalMediaDataSource,
    required this.travelDocumentId,
    required this.folderId,
    required this.authRepository,
    required this.travelItemRepository,
    required this.index,
  }) : super(const CreatePhotoWidgetState.initial());

  WTaskEither<UpsertWidgetOutput> _createPhotoWidget({
    required String mediaId,
    required ProcessImageServiceProcessedImage processedImage,
  }) {
    final photo = PhotoWidgetModel(
      id: const Uuid().v4(),
      mediaId: mediaId,
      url: null,
      // The order does not matter at creation time.
      // It will be updated by the repository.
      order: 0,
      travelDocumentId: travelDocumentId,
      byteCount: processedImage.byteCount,
      latLng: processedImage.latLng,
      size: processedImage.size,
      folderId: folderId,
      mediaExtension: extension(processedImage.file.path),
      takenAt: processedImage.takenAt,
    );
    return travelItemRepository.createWidget(
      widget: photo,
      index: index,
    );
  }

  /// Launches the picker to select images from the gallery and processes them.
  Future<void> pick() async {
    logger.d(
      'Launching $CreatePhotoWidgetCubit pick process {travelDocumentId: '
      '$travelDocumentId, folderId: $folderId, index: $index}',
    );
    final pickedImages = await ImagePicker().pickMultiImage(
      maxWidth: 2560,
      maxHeight: 2560,
    );

    if (pickedImages.isEmpty) {
      logger.d('No images picked');
      emit(state.copyWith(status: StateStatus.success));
      return;
    }

    logger.d(
      'Picked ${pickedImages.length} images: '
      '${pickedImages.map((e) => e.path).join(', ')}',
    );

    emit(
      state.copyWith(
        requests: pickedImages,
        status: StateStatus.progress,
      ),
    );

    for (final file in pickedImages) {
      logger.d('Processing image: ${file.path}');
      emit(
        state.copyWith(
          requests: pickedImages,
          status: StateStatus.progress,
          index: pickedImages.indexOf(file),
        ),
      );
      final mediaId = const Uuid().v4();

      final destinationPath = travelDocumentLocalMediaDataSource.getMediaPath(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
        mediaWidgetFeatureId: mediaId,
        mediaExtension: extension(file.path),
      );
      logger.d('The image will be saved at: $destinationPath');

      final processor = ProcessImageService(
        imageFile: file,
        maxWidth: 2560,
        maxHeight: 2560,
        absoluteDestinationPath: destinationPath,
      );

      await processor
          .task()
          .flatMap(
            (processedImage) => _createPhotoWidget(
              mediaId: mediaId,
              processedImage: processedImage,
            ),
          )
          .match(
            (err) => emit(
              state.copyWith(
                // Never emit failure, only progress and success
                // even if some images failed to be processed.
                status: StateStatus.progress,
                errors: [
                  ...state.errors,
                  (error: err, file: file),
                ],
              ),
            ),
            (result) => emit(
              state.copyWith(
                status: StateStatus.progress,
                processed: [
                  ...state.processed,
                  result.widget as PhotoWidgetModel,
                ],
              ),
            ),
          )
          .run();
    }

    logger.i(
      'Finished processing ${pickedImages.length} images: '
      '${pickedImages.map((e) => e.path).join(', ')}',
    );
    emit(
      state.copyWith(
        status: StateStatus.success,
        requests: pickedImages,
      ),
    );
  }
}
