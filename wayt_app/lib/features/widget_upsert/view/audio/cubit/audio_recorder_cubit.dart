import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'audio_recorder_state.dart';

/// {@template audio_recorder_cubit}
/// Cubit for handling audio recorder.
/// {@endtemplate}
class AudioRecorderCubit extends Cubit<AudioRecorderState> {
  /// {@macro audio_recorder_cubit}
  /// Creates an instance of [AudioRecorderCubit] with an initial state.
  AudioRecorderCubit() : super(const AudioRecorderState.initial());

  /// Sets the audio recorder state to recording
  void onStartRecording(String path) => emit(
        state.copyWith(
          recorderState: AudioState.recording,
          audioPath: Option.of(path),
        ),
      );

  /// Reset the audio recorder state to initial.
  void onCancelRecording() => emit(
        const AudioRecorderState.initial(),
      );
}
