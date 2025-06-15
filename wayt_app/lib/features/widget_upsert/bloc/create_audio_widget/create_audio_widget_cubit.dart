import 'dart:io';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import 'process_audio_file_service.dart';

part 'create_audio_widget_state.dart';

/// {@template create_audio_widget_cubit}
/// Cubit for creating a audio widget.
///
/// The listener should be implemented so that:
/// - As long as the cubit is in [StateStatus.progress] the user should not
///   interact with the UI.
/// {@endtemplate}
// TODO: can be replaced with a TaskCubit
class CreateAudioWidgetCubit extends Cubit<CreateAudioWidgetState>
    with LoggerMixin {
  /// The ID of the travel document where the audio widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder where the audio widget will be added.
  final String? folderId;

  /// The travel item repository.
  final AuthRepository authRepository;

  /// The index where the audio widget will be added.
  ///
  /// If `null`, the audio widget will be added at the end of the list.
  final int? index;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// {@macro create_audio_widget_cubit}
  CreateAudioWidgetCubit({
    required this.travelDocumentLocalMediaDataSource,
    required this.travelDocumentId,
    required this.folderId,
    required this.authRepository,
    required this.travelItemRepository,
    required this.index,
  }) : super(const CreateAudioWidgetState.initial());

  WTaskEither<UpsertWidgetOutput> _createAudioWidget({
    required String mediaId,
    required ProcessAudioFileServiceProcessedFile processedFile,
    required int duration,
  }) {
    final file = AudioWidgetModel(
      id: const Uuid().v4(),
      mediaId: mediaId,
      url: null,
      name: 'Audio ${DateFormat('d MMM yyyy, HH:mm').format(DateTime.now())}',
      duration: duration,
      // The order does not matter at creation time.
      // It will be updated by the repository.
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

  /// Processes the audio file and creates a new audio widget.
  Future<void> process({
    required String tempAudioPath,
    required String mediaId,
    required int duration,
  }) async {
    emit(state.copyWith(status: StateStatus.success));

    final destinationPath = travelDocumentLocalMediaDataSource.getMediaPath(
      travelDocumentId: travelDocumentId,
      folderId: folderId,
      mediaWidgetFeatureId: mediaId,
      mediaExtension: extension(tempAudioPath),
    );
    logger.d('The audio file will be copied at: $destinationPath');

    final processor = ProcessAudioFileService(
      file: File(tempAudioPath),
      absoluteDestinationPath: destinationPath,
    );

    await processor
        .task()
        .flatMap(
          (file) => _createAudioWidget(
            mediaId: mediaId,
            processedFile: file,
            duration: duration,
          ),
        )
        .match((err) {
      emit(state.copyWithError(err));
    }, (result) {
      emit(state.copyWith(status: StateStatus.success));
    }).run();
  }
}
