import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flext/flext.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:path/path.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../file/file.dart';

part 'create_file_widget_state.dart';

/// {@template create_file_widget_cubit}
/// Cubit for creating a file widget.
///
/// This cubit is responsible for picking files from the device and processing
/// them one by one to create a file widget for each file picked.
///
/// The listener should be implemented so that:
/// - As long as the cubit is in [StateStatus.progress] the user should not
///   interact with the UI.
/// - The user should see the progress of the file processing based on the
///   index of the file being processed and the total number of files.
/// - Single processing errors **are NOT notified** via [StateStatus.failure].
///   The count of errors is available in the state
///   [CreateFileWidgetState.errors].
/// - Once the processing is done ([StateStatus.success]), the purpose of this
///   cubit is complete, thus we normally expect the cubit to be closed. E.g.,
///   the modal that was using the cubit is popped.
/// - When the processing is done, do not ever expect [StateStatus.failure], it
///   will always be [StateStatus.success] even though some files may have
///   failed to be processed.
/// - Notify to the user the errors that occurred during processing using the
///   [CreateFileWidgetState.errors] list.
/// {@endtemplate}
class CreateFileWidgetCubit extends Cubit<CreateFileWidgetState>
    with LoggerMixin {
  /// {@macro create_file_widget_cubit}
  CreateFileWidgetCubit({
    required this.travelDocumentLocalMediaDataSource,
    required this.travelDocumentId,
    required this.folderId,
    required this.authRepository,
    required this.travelItemRepository,
    required this.index,
  }) : super(const CreateFileWidgetState.initial());

  /// The ID of the travel document where the file widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder where the file widget will be added.
  final String? folderId;

  /// The travel item repository.
  final AuthRepository authRepository;

  /// The index where the file widget will be added.
  ///
  /// If `null`, the file widget will be added at the end of the list.
  final int? index;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  WTaskEither<UpsertWidgetOutput> _createFileWidget({
    required String mediaId,
    required ProcessFileServiceProcessedFile processedFile,
  }) {
    final file = FileWidgetModel(
      id: const Uuid().v4(),
      mediaId: mediaId,
      url: processedFile.file.path,
      name: basenameWithoutExtension(processedFile.originalFileName),
      // The order does not matter at creation time.
      // It will be updated by the repositor ̑y.
      order: 0,
      travelDocumentId: travelDocumentId,
      byteCount: processedFile.byteCount,
      folderId: folderId,
      mediaExtension: extension(processedFile.file.path),
    );
    return travelItemRepository.createWidget(
      widget: file,
      index: index,
    );
  }

  /// Processes a list of files to create file widgets.
  Future<void> process(List<XFile> files) async {
    if (files.isEmpty) {
      emit(state.copyWith(status: StateStatus.success));
      return;
    }
    emit(
      state.copyWith(
        requests: files,
        status: StateStatus.progress,
      ),
    );

    for (final file in files) {
      emit(
        state.copyWith(
          requests: files,
          status: StateStatus.progress,
          index: files.indexOf(file),
        ),
      );
      final mediaId = const Uuid().v4();

      final destinationPath = travelDocumentLocalMediaDataSource.getMediaPath(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
        mediaWidgetFeatureId: mediaId,
        mediaExtension: extension(file.path),
      );

      final processor = ProcessFileService(
        file: file,
        absoluteDestinationPath: destinationPath,
      );

      await processor
          .task()
          .flatMap(
            (processedFile) => _createFileWidget(
              mediaId: mediaId,
              processedFile: processedFile,
            ),
          )
          .match(
            (err) => emit(
              state.copyWith(
                // Never emit failure, only progress and success
                // even if some files failed to be processed.
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
                  result.widget as FileWidgetModel,
                ],
              ),
            ),
          )
          .run();
    }
    logger.i('Finished processing ${files.length} files');
    emit(
      state.copyWith(
        status: StateStatus.success,
        requests: files,
      ),
    );
  }
}
