part of 'create_audio_widget_cubit.dart';

/// State of the [CreateAudioWidgetCubit].
// TODO: can be replaced with a TaskCubitState
final class CreateAudioWidgetState extends SuperBlocState<WError> {
  const CreateAudioWidgetState._({
    required super.status,
    super.error,
  });

  /// The initial state of the [CreateAudioWidgetCubit].
  const CreateAudioWidgetState.initial() : super.initial();

  @override
  CreateAudioWidgetState copyWith({required StateStatus status}) {
    return CreateAudioWidgetState._(
      status: status,
    );
  }

  @override
  CreateAudioWidgetState copyWithError(WError error) {
    return CreateAudioWidgetState._(
      status: StateStatus.failure,
      error: error,
    );
  }
}
