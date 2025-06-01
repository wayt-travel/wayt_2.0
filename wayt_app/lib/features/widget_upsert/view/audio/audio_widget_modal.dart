import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import 'audio.dart';

/// Modal for adding a audio widget
class AudioWidgetModal extends StatelessWidget {
  const AudioWidgetModal._();

  /// Pushes the modal to the navigator.
  static void show({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
    required int? index,
    required String? folderId,
  }) {
    context.navRoot.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (ctx) {
          return BlocProvider(
            create: (context) => AudioRecorderCubit(),
            child: const AudioWidgetModal._(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIXME: l10n
        title: const Text('Add audio widget'),
      ),
      floatingActionButton:
          BlocSelector<AudioRecorderCubit, AudioRecorderState, AudioState>(
        selector: (state) {
          return state.recorderState;
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state.isIdle) {
                // TEMP: use hardcoded path
                context.read<AudioRecorderCubit>().onStartRecording('path');
              }
            },
            child: Icon(
              state.isIdle ? Icons.mic_rounded : Icons.save_rounded,
            ),
          );
        },
      ),
      body: Center(
        child: BlocSelector<AudioRecorderCubit, AudioRecorderState, AudioState>(
          selector: (state) {
            return state.recorderState;
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TEMP: show elasped time when recording
                Text(
                  // FIXME: l10n
                  state.isIdle
                      ? 'Click the button below to start recording'
                      : '00:00',
                  textAlign: TextAlign.center,
                ),
                if (state.isRecording) ...[
                  Gap($.style.insets.sm),
                  TextButton(
                    onPressed: () {
                      context.read<AudioRecorderCubit>().onCancelRecording();
                    },
                    child: const Text(
                      // FIXME: l10n
                      'Cancel recording',
                    ),
                  )
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
