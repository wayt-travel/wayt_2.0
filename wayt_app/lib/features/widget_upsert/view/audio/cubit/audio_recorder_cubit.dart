import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/context/app_context.dart';
import '../../../../../repositories/repositories.dart';

part 'audio_recorder_state.dart';

/// {@template audio_recorder_cubit}
/// Cubit for handling audio recorder.
///
/// It is charge of creating and building the direcotry and the output path of
/// the audio file.
/// {@endtemplate}
class AudioRecorderCubit extends Cubit<AudioRecorderState> with LoggerMixin {
  /// The ID of the travel document where the photo widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder where the photo widget will be added.
  final String? folderId;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// {@macro audio_recorder_cubit}
  /// Creates an instance of [AudioRecorderCubit] with an initial state.
  AudioRecorderCubit({
    required this.travelDocumentId,
    required this.folderId,
    required this.travelDocumentLocalMediaDataSource,
  }) : super(const AudioRecorderState.initial());

  /// Sets the audio recorder state to recording
  void onStartRecording() {
    logger.v('Attempt to start audio recording...');
    final mediaId = const Uuid().v4();

    // The file is saved with MP4 extension.
    // The encoding is still AAC but we faced some issues on iOS in
    // reproducing audios recorded on Android and saved with .aac
    // extension.
    // We tested that with mp4 extension everything works on iOS, Android and
    // Web (Chrome and Safari as well).
    final tempDestinationPath = join(
      AppContext.I.temporaryDirectory.path,
      '$mediaId.mp4',
    );


    logger.d('The audio will be saved at: $tempDestinationPath');
    emit(
      state.copyWith(
        recorderState: AudioState.recording,
        audioPath: Option.of(tempDestinationPath),
        mediaId: Option.of(mediaId),
      ),
    );
  }

  /// Resets the audio recorder state to initial and delete the file audio.
  void onCancelRecording() {
    state.audioPath.match(
      () => null,
      (path) {
        logger.v('Try to delete audio from $path');
        try {
          File(path).deleteSync();
        } on Exception catch (e, s) {
          logger.e(e.toString(), e, s);
        }
      },
    );
    emit(
      const AudioRecorderState.initial(),
    );
  }

  /// Stops the audio recording.
  void onStopRecording() {
    logger.v('Attempt to stop audio recording...');
    emit(state.copyWith(recorderState: AudioState.idle));
  }
}
