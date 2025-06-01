import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';
import '../../../../widgets/widgets.dart';
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
    return PopScope(
      canPop: context.watch<AudioRecorderCubit>().state.recorderState.isIdle,
      onPopInvokedWithResult: (didPop, res) {
        if (!didPop) {
          // FIXME: l10n
          const message =
              'There is a recording in progress. Finish it before you '
              'can go back.';
          SnackBarHelper.I.showWarning(
            context: context,
            message: message,
          );
        }
      },
      child: Scaffold(
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
              onPressed: () async {
                if (state.isIdle) {
                  // Gives a long press feedback to the user.
                  AppHaptics.lightImpact().ignore();

                  // If the permission for recording is not granted yet,
                  // the audio recording must not start.
                  if (!await WPermissions.microphone.isGranted &&
                      context.mounted) {
                    if (!await WPermissions.microphone.requestWithAlert(
                      context: context,
                      // FIXME: l10n
                      alertMessage:
                          'Unable to record audio. You have not granted Wayt '
                          'permission to access the microphone.',
                    )) {
                      return;
                    }
                  }
                  if (context.mounted) {
                    // TEMP: use hardcoded path
                    context.read<AudioRecorderCubit>().onStartRecording('path');
                  }
                }
              },
              child: Icon(
                state.isIdle ? Icons.mic_rounded : Icons.save_rounded,
              ),
            );
          },
        ),
        body: Center(
          child:
              BlocSelector<AudioRecorderCubit, AudioRecorderState, AudioState>(
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
      ),
    );
  }
}
