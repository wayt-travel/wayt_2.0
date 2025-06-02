import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:record/record.dart';

import '../../../../core/core.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/widgets.dart';
import '../../bloc/create_audio_widget/create_audio_widget_cubit.dart';
import 'audio.dart';

/// The body of the [AudioWidgetModal].
class AudioWidgetModalBody extends StatefulWidget {
  /// Creates a new instance of [AudioWidgetModalBody].
  const AudioWidgetModalBody({super.key});

  @override
  State<AudioWidgetModalBody> createState() => _AudioWidgetModalBodyState();
}

class _AudioWidgetModalBodyState extends State<AudioWidgetModalBody> {
  final _audioRecorder = AudioRecorder();
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onInactive: () {
        if (context.mounted &&
            context
                .read<AudioRecorderCubit>()
                .state
                .recorderState
                .isRecording) {
          context.read<AudioRecorderCubit>().onCancelRecording();
        }
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<AudioRecorderCubit, AudioRecorderState>(
        listenWhen: (previous, current) =>
            previous.recorderState != current.recorderState,
        listener: (context, state) async {
          if (state.recorderState.isRecording) {
            state.audioPath.match(
              () {
                SnackBarHelper.I.showError(
                  context: context,
                  // FIXME: l10n
                  message: 'No audio path available for recording',
                );
              },
              (path) {
                _audioRecorder.start(const RecordConfig(), path: path);
              },
            );
          }

          /// This state is emitted when the recording is stopped or cancelled.
          /// If the audio path is available, the recording is stopped and has
          /// to be processed.
          if (state.recorderState.isIdle) {
            await _audioRecorder.stop(); // or cancel

            unawaited(
              state.audioPath
                  .flatMap(
                (path) => state.mediaId.map(
                  (mediaId) => (path, mediaId),
                ),
              )
                  .match(() {
                return null;
              }, (tuple) async {
                // create the audio widget with path
                // get the duration of the audio file
                // Player is init and then we called [setUrl] only for the
                // audio's duration
                final player = audioplayers.AudioPlayer();

                player.onDurationChanged.listen(
                  (duration) {
                    // when duration is available, create the audio widget.
                    if (context.mounted) {
                      final cubit = CreateAudioWidgetCubit(
                        travelDocumentId: context
                            .read<AudioWidgetParametersProvider>()
                            .state
                            .travelDocumentId,
                        folderId: context
                            .read<AudioWidgetParametersProvider>()
                            .state
                            .folderId,
                        index: context
                            .read<AudioWidgetParametersProvider>()
                            .state
                            .index,
                        authRepository: $.repo.auth(),
                        travelItemRepository: $.repo.travelItem(),
                        travelDocumentLocalMediaDataSource:
                            TravelDocumentLocalMediaDataSource.I,
                      );
                      unawaited(
                        context.navRoot.pushBlocListenerBarrier<
                            CreateAudioWidgetCubit, CreateAudioWidgetState>(
                          bloc: cubit,
                          trigger: () => cubit.process(
                            tempAudioPath: tuple.$1,
                            mediaId: tuple.$2,
                            duration: duration.inMilliseconds,
                          ),
                          listenWhen: (previous, current) =>
                              current.status.isFailure ||
                              current.status.isSuccess,
                          listener: (context, state) {
                            // Pop the barrier
                            context.navRoot.pop();
                            if (state.status.isFailure) {
                              SnackBarHelper.I.showError(
                                context: context,
                                message: state.error!.userIntlMessage(context),
                              );
                            }
                            if (state.status.isSuccess) {
                              SnackBarHelper.I.showInfo(
                                context: context,
                                // FIXME: l10n
                                message: 'Audio added successfully',
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                );

                await player.setSourceDeviceFile(tuple.$1);
              }),
            );
          }
        },
        child: BlocSelector<AudioRecorderCubit, AudioRecorderState, AudioState>(
          selector: (state) {
            return state.recorderState;
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TEMP: show elasped time when recording
                if (state.isIdle)
                  const Text(
                    // FIXME: l10n
                    'Click the button below to start recording',
                    textAlign: TextAlign.center,
                  ),
                if (state.isRecording) ...[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlinkingDot(color: Colors.red),
                      Gap(8),
                      AudioElapsedTime(),
                    ],
                  ),
                  Gap($.style.insets.sm),
                  TextButton(
                    onPressed: () {
                      context.read<AudioRecorderCubit>().onCancelRecording();
                    },
                    child: const Text(
                      // FIXME: l10n
                      'Cancel recording',
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
