import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../features.dart';

/// {@template audio_widget_tile}
/// Tile to display a audio widget in a travel document.
/// {@endtemplate}
class AudioWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The file widget to display.
  final AudioWidgetModel audio;

  /// {@macro audio_widget_tile}
  const AudioWidgetTile({
    required this.index,
    required this.audio,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final durationStyle = context.tt.labelSmall;
    return TravelWidgetGestureWrapper(
      onTapOverride: Option.of((_, __) {
        context.read<SelectedAudioTileCubit>().onSelected(audio);
      }),
      index: index,
      travelItem: audio,
      child: Card.outlined(
        margin: EdgeInsets.symmetric(
          vertical: $insets.xxs,
          horizontal: $insets.xs,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.mic_rounded,
                      color: context.col.primary,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ), // Spazio verticale simile al ListTile
                      child: Text(
                        'Audio',
                        style: context.tt.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<SelectedAudioTileCubit, AudioWidgetModel?>(
                builder: (context, state) {
                  if (state == audio) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TODO: add track of audio player
                            // TEMP: calculate time in progess
                            Text(
                              Duration.zero.toHhMmSsString(),
                              style: durationStyle,
                            ),
                            Text(
                              audio.duration.toHhMmSsString(),
                              style: durationStyle,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            size: 48,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
