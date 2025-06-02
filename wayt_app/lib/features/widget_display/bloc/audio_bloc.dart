import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../error/error.dart';
import '../../../managers/managers.dart';

part 'audio_event.dart';
part 'audio_state.dart';

/// The BLoC for managing audio playback events and states.
///
/// The state emits can be:
///
/// - [AudioInitial] when the bloc is first created.
///
/// - [AudioPlayInProgress] even when the audio is paused.
///
/// - [AudioPlayComplete] when the audio playback is completed.
///
/// The paused state is not emitted. It is handled as a [AudioPlayInProgress]
/// with the current position of the audio.
///
/// It listens to the audio manager's stream to update its state.
class AudioBloc extends Bloc<AudioEvent, AudioState> with LoggerMixin {
  final AudioManager _audioManager;

  /// Creates a new instance of [AudioBloc].
  AudioBloc({
    required AudioManager audioManager,
  })  : _audioManager = audioManager,
        super(AudioInitial()) {
    on<_AudioPositionSubscriptionRequested>((event, emit) async {
      await emit.onEach(
        _audioManager.onPositionChanged,
        onData: (progress) {
          logger.d('Audio position updated: $progress');
          _audioManager.currentAudio.map((audio) {
            final maxMilliseconds = audio.duration.inMilliseconds.toDouble();
            final milliseconds =
                min(progress.inMilliseconds.toDouble(), maxMilliseconds);
            emit(
              AudioPlayInProgress(
                audioId: audio.id,
                progress: Duration(
                  milliseconds: milliseconds.ceil(),
                ),
              ),
            );
          });
        },
      );
    });

    on<_AudioStateSubscriptionRequested>((event, emit) async {
      await emit.onEach(
        _audioManager.onPlayerStateChanged,
        onData: (playerState) {
          if (playerState == PlayerState.completed) {
            _audioManager.currentAudio.map(
              (audio) => emit(
                AudioPlayComplete(audioId: audio.id),
              ),
            );
            _audioManager.resetCurrentAudio();
          }
        },
      );
    });
    on<AudioPlayed>((event, emit) {
      try {
        _audioManager.play(event.audio);
      } catch (e, s) {
        logger.e(e.toString(), e, s);
        add(
          AudioPlayFailed(
            audio: event.audio,
            error: $errors.server.api.noInternet,
          ),
        );
      }
    });
    on<AudioPaused>((event, emit) async {
      // No need to emit a new state, because the audioplayer
      // listener callback is in charge to controlling the state
      await _audioManager.pause();
    });
    on<AudioPlayFailed>(
      (event, emit) async => emit(
        AudioPlayFailure(
          event.audio.id,
          event.error,
        ),
      ),
    );
    on<AudioResumed>((event, emit) async {
      await _audioManager.resume();
    });

    // Subscribe to audio position and audio player state changes.
    add(const _AudioPositionSubscriptionRequested());
    add(const _AudioStateSubscriptionRequested());
  }
}
