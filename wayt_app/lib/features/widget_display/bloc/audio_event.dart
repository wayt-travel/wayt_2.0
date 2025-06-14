part of 'audio_bloc.dart';

/// The events that can be dispatched to the [AudioBloc].
sealed class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

/// The events with the audio that is being interacted with.
sealed class AudioEventWithAudio extends AudioEvent {
  const AudioEventWithAudio(this.audio);

  /// {@template audio_event_audio}
  /// The audio that is being interacted with.
  /// {@endtemplate}
  final Audio audio;

  @override
  List<Object> get props => [audio];
}

/// Requested to subscribe to audio position updates.
final class _AudioPositionSubscriptionRequested extends AudioEvent {
  const _AudioPositionSubscriptionRequested();
}

/// Requested to subscribe to audio player state updates.
final class _AudioStateSubscriptionRequested extends AudioEvent {
  const _AudioStateSubscriptionRequested();
}

/// {@template audio_event_played}
/// Event to request the audio to be played.
/// {@endtemplate}
class AudioPlayed extends AudioEventWithAudio {
  /// {@macro audio_event_played}
  const AudioPlayed(super.audio);
}

/// {@template audio_event_resumed}
/// Event to request the audio to be resumed.
/// {@endtemplate}
class AudioResumed extends AudioEventWithAudio {
  /// {@macro audio_event_resumed}
  const AudioResumed(super.audio);
}

/// {@template audio_event_seek_manually_updated}
/// Event to request the audio to seek to a specific position.
///
/// The [progress] is the current position of the audio playback.
/// {@endtemplate}
class AudioSeekManuallyUpdated extends AudioEventWithAudio {
  /// Indicates the current position of the audio playback.
  final Duration progress;

  /// {@macro audio_event_seek_manually_updated}
  const AudioSeekManuallyUpdated({
    required Audio audio,
    required this.progress,
  }) : super(audio);

  @override
  List<Object> get props => [...super.props, progress];
}

/// {@template audio_event_paused}
/// Event to request the audio to be paused.
/// {@endtemplate}
class AudioPaused extends AudioEventWithAudio {
  /// {@macro audio_event_paused}
  const AudioPaused(super.audio);

  @override
  List<Object> get props => [...super.props, audio];
}

/// {@template audio_event_failed}
/// Event to request the audio playback to fail.
/// {@endtemplate}
class AudioPlayFailed extends AudioEventWithAudio {
  /// The error that occurred during the audio playback.
  final WError error;

  /// {@macro audio_event_failed}
  const AudioPlayFailed({
    required Audio audio,
    required this.error,
  }) : super(audio);

  @override
  List<Object> get props => [...super.props, error];
}
