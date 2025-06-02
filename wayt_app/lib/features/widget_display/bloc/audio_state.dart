part of 'audio_bloc.dart';

/// The states of the [AudioBloc].
sealed class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

/// The initial state of the [AudioBloc].
class AudioInitial extends AudioState {}

/// The state when an audio is being played.
class AudioPlayInProgress extends AudioState {
  /// The id of the audio being played.
  final String audioId;

  /// The current progress of the audio playback.
  final Duration progress;

  /// Creates a new instance of [AudioPlayInProgress].
  const AudioPlayInProgress({required this.audioId, required this.progress});

  @override
  List<Object> get props => [audioId, progress];
}

/// The state when an audio has completed playing.
class AudioPlayComplete extends AudioState {
  /// The id of the audio that has completed playing.
  final String audioId;

  /// Creates a new instance of [AudioPlayComplete].
  const AudioPlayComplete({required this.audioId});

  @override
  List<Object> get props => [audioId];
}

/// The state when an audio playback has been paused.
/// The audio can be resumed from this state.
class AudioPlayPaused extends AudioState {
  /// The id of the audio that has paused.
  final String audioId;

  /// Creates a new instance of [AudioPlayPaused].
  const AudioPlayPaused({required this.audioId});

  @override
  List<Object> get props => [audioId];
}

/// The state when an audio playback has failed.
class AudioPlayFailure extends AudioState {
  /// The id of the audio that failed to play.
  final String audioId;

  /// The error that occurred during audio playback.
  final WError error;

  /// Creates a new instance of [AudioPlayFailure].
  const AudioPlayFailure(this.audioId, this.error);

  @override
  List<Object> get props => [audioId, error];
}
