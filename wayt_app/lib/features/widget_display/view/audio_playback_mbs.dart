import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

import '../../../managers/managers.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

/// Displays a modal bottom sheet for audio playback.
class AudioPlaybackMbs extends StatelessWidget {
  const AudioPlaybackMbs._(this.audioWidget);

  /// The audio widget to display.
  final AudioWidgetModel audioWidget;

  /// Shows the modal bottom sheet.
  ///
  /// An instance of an [AudioBloc] is created and provided to the context.
  static Future<void> show(
    BuildContext context, {
    required AudioWidgetModel audioWidget,
  }) =>
      ModalBottomSheet.of(context).showShrunk(
        childrenBuilder: (context) => [
          BlocProvider(
            create: (context) => AudioBloc(audioManager: GetIt.I.get()),
            child: AudioPlaybackMbs._(audioWidget),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final durationStyle = context.tt.labelSmall;
    return Column(
      children: [
        BlocBuilder<AudioBloc, AudioState>(
          buildWhen: (previous, current) {
            return current is AudioPlayInProgress ||
                current is AudioPlayComplete;
          },
          builder: (context, state) {
            final audioManager = GetIt.I.get<AudioManager>();
            final bloc = context.read<AudioBloc>();

            // Indicates the progress of the audio playback.
            // If audio is playing, it will be the current position, otherwise
            // it will be zero aka the starting point.
            var sliderProgress = Duration.zero;

            // Indicates the remaining time of the audio playback.
            // The starting point is the duration of the audio.
            var remainingTime = audioWidget.duration;

            if (state is AudioPlayInProgress &&
                state.audioId == audioWidget.id) {
              sliderProgress = state.progress;
              remainingTime = Duration(
                milliseconds: audioWidget.duration.inMilliseconds -
                    sliderProgress.inMilliseconds,
              );
            }
            if (state is AudioPlayComplete && state.audioId == audioWidget.id) {
              sliderProgress = Duration.zero;
              remainingTime = audioWidget.duration;
            }

            final audio = Audio(
              id: audioWidget.id,
              path: audioWidget.localPath!,
              duration: audioWidget.duration,
              isLocal: true,
            );
            return Column(
              children: [
                AudioPlayerSlider(
                  progress: sliderProgress,
                  duration: audioWidget.duration,
                ),
                Gap($style.insets.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sliderProgress.toHhMmSsString(),
                      style: durationStyle,
                    ),
                    Text(
                      remainingTime.toHhMmSsString(),
                      style: durationStyle,
                    ),
                  ],
                ),
                // Use the current state from the audio manager because, the
                // state of the bloc is never paused. So is impossible to
                // determine if the audio is paused or not. This because we want
                // to keep the current position of the audio, even when it is
                // paused. An alternative would be to create an updated state
                // from the inProgress to keep the current position.
                // It is guaranteed that the state of the player from the audio
                // manager is updated when it is used.
                IconButton(
                  onPressed: () {
                    if (audioManager.isPlaying) {
                      if (audioManager.currentAudio.fold(
                        () => false,
                        (current) => current.id == audio.id,
                      )) {
                        bloc.add(AudioPaused(audio));
                      } else {
                        bloc.add(AudioResumed(audio));
                      }
                    } else {
                      bloc.add(AudioPlayed(audio));
                    }
                  },
                  icon: Icon(
                    audioManager.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 48,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A slider widget for audio playback, showing the current position and the
/// remaining time.
class AudioPlayerSlider extends StatelessWidget {
  /// Creates a new instance of [AudioPlayerSlider].
  const AudioPlayerSlider({
    required this.progress,
    required this.duration,
    super.key,
  });

  /// The current progress of the audio playback.
  final Duration progress;

  /// The total duration of the audio playback.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: SliderTheme(
        data: const SliderThemeData(),
        child: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            return Slider(
              value: progress.inMilliseconds.toDouble(),
              onChanged: (value) {
                final audioManager = GetIt.I.get<AudioManager>();
                context.read<AudioBloc>().add(
                      AudioSeekManuallyUpdated(
                        audio: audioManager.currentAudio.fold(
                          () => throw ArgumentError.value(
                            audioManager.currentAudio,
                            'currentAudio',
                            'Expected an audio, but got None.',
                          ),
                          (audio) => audio,
                        ),
                        progress: Duration(milliseconds: value.toInt()),
                      ),
                    );
              },
              min: 0,
              max: duration.inMilliseconds.toDouble(),
            );
          },
        ),
      ),
    );
  }
}

/// Custom track shape for the audio slider.
class CustomAudioTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width - 4;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
