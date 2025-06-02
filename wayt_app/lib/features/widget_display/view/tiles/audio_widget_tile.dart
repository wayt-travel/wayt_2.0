import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../features.dart';
import '../audio_playback_mbs.dart';

/// {@template audio_widget_tile}
/// Tile to display a audio widget in a travel document.
///
/// It show a trailing with the mic icon, the title and the duration of the
/// audio widget.
///
/// Default title is "Audio", but in the future perhaps it can be edited by
/// the user.
/// {@endtemplate}
class AudioWidgetTile extends StatelessWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The audio widget to display.
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
        AudioPlaybackMbs.show(context, audioWidget: audio);
      }),
      index: index,
      travelItem: audio,
      child: Card.outlined(
        margin: EdgeInsets.symmetric(
          vertical: $insets.xxs,
          horizontal: $insets.xs,
        ),
        child: ListTile(
          leading: Icon(
            Icons.mic_rounded,
            color: context.col.primary,
          ),
          title: Text(
            'Audio',
            style: context.tt.bodyLarge,
          ),
          trailing: Text(
            audio.duration.toHhMmSsString(),
            style: durationStyle,
          ),
        ),
      ),
    );
  }
}
