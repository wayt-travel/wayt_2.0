part of 'audio_recorder_cubit.dart';

/// The state of the audio recorder.
enum AudioState {
  /// The audio recorder is idle, not recording.
  idle,

  /// The audio recorder is currently recorrding.
  recording;

  /// Indicates whether the audio recorder is recording.
  bool get isRecording => this == AudioState.recording;
  
  /// Indicates whether the audio recorder is idle.
  bool get isIdle => this == AudioState.idle;
}

/// State of the [AudioRecorderCubit].
final class AudioRecorderState extends Equatable {
  /// The state of the audio recorder.
  final AudioState recorderState;

  /// The path to the recorded audio file.
  final Option<String> audioPath;

  /// Creates a new instance of [AudioRecorderState].
  const AudioRecorderState.initial()
      : recorderState = AudioState.idle,
        audioPath = const Option.none();

  const AudioRecorderState._({
    required this.recorderState,
    required this.audioPath,
  });

  /// Creates a new instance of [AudioRecorderState].
  AudioRecorderState copyWith({
    AudioState? recorderState,
    Option<String>? audioPath,
  }) {
    return AudioRecorderState._(
      recorderState: recorderState ?? this.recorderState,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object?> get props => [recorderState, audioPath];
}
