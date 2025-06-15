import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fpdart/fpdart.dart';

/// An Audio resource handled bu the [AudioManager].
class Audio {
  /// The id of the audio.
  final String id;

  /// The path of the audio
  final String path;

  /// The duration of the audio.
  final Duration duration;

  /// Indicates whether the audio is a local file.
  final bool isLocal;

  /// Creates a new instance of [Audio].
  Audio({
    required this.id,
    required this.path,
    required this.duration,
    required this.isLocal,
  });
}

/// The manger for handling audio playback.
class AudioManager {
  final AudioPlayer _player;

  Option<Audio> _currentAudio;

  /// Creates a new instance of [AudioManager].
  AudioManager({required AudioPlayer player})
      : _player = player,
        _currentAudio = const Option.none();

  // Streams

  /// Stream that emits updates on the current position of the audio track
  /// during playback.
  ///
  /// This stream provides a `Duration` representing the elapsed time since
  /// the track started,
  /// updated periodically while the audio is playing. It can be used to
  /// update the UI with the
  /// playback progress or to implement features like an audio player with
  /// a progress indicator.
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  /// Stream that emits the current state of the audio player.
  /// Only the [PlayerState.completed] state is handled.
  ///
  /// This stream can be replaced with the `_player.onPlayerComplete`.
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  // Getters
  /// Gets the current audio being played.
  Option<Audio> get currentAudio => _currentAudio;

  /// Gets the current player's state.
  // Might be useless
  PlayerState get playerState => _player.state;

  /// Indicates whether the audio is currently playing.
  bool get isPlaying => playerState == PlayerState.playing;

  /// Indicates whether the audio is paused.
  bool get isPaused => playerState == PlayerState.paused;

  /// Indicates whether the audio is completed.
  bool get isCompleted => playerState == PlayerState.completed;

  void _setCurrentAudioAndSubscriptions(Audio audio) {
    _currentAudio = Some(audio);
  }

  /// Plays the given [audio].
  Future<void> play(Audio audio) async {
    _setCurrentAudioAndSubscriptions(audio);
    if (audio.isLocal) {
      await _player.play(DeviceFileSource(audio.path));
    } else {
      // TODO: check the internet connection before playing.
      await _player.play(UrlSource(audio.path));
    }
  }

  /// Updates the current audio playback position.
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Pauses the current audio playback.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Stops the current audio playback.
  Future<void> stop() async {
    await _player.stop();
  }

  /// Resumes the current audio playback.
  Future<void> resume() async {
    await _player.resume();
  }

  /// Reset the current audio when playback is complete.
  void resetCurrentAudio() {
    _currentAudio = const Option.none();
  }

  /// Disposes the audio player.
  /// This should be called when the audio manager is no longer needed.
  void dispose() {
    _player.dispose().ignore();
  }
}
