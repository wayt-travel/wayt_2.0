part of 'create_file_widget_cubit.dart';

/// State of the [CreateFileWidgetState].
final class CreateFileWidgetState extends SuperBlocState<WError> {
  /// List of file requests to be processed.
  final List<XFile> requests;

  /// List of processed photo requests.
  final List<FileWidgetModel> processed;

  /// List of errors that occurred during processing.
  final List<({XFile file, WError error})> errors;

  /// The index of the current request being processed.
  final int index;

  /// The current request being processed.
  dynamic get inProcessRequest =>
      index.isBetween(0, requests.length - 1) ? requests[index] : null;

  const CreateFileWidgetState._({
    required this.requests,
    required this.processed,
    required this.errors,
    required this.index,
    required super.status,
    super.error,
  });

  /// The initial state of the [CreateFileWidgetCubit].
  const CreateFileWidgetState.initial()
      : requests = const [],
        processed = const [],
        errors = const [],
        index = -1,
        super.initial();

  @override
  CreateFileWidgetState copyWith({
    required StateStatus status,
    List<FileWidgetModel>? processed,
    List<XFile>? requests,
    List<({XFile file, WError error})>? errors,
    int? index,
  }) {
    return CreateFileWidgetState._(
      requests: requests ?? this.requests,
      processed: processed ?? this.processed,
      errors: errors ?? this.errors,
      index: index ?? this.index,
      error: error,
      status: status,
    );
  }

  @override
  CreateFileWidgetState copyWithError(WError error) {
    return CreateFileWidgetState._(
      requests: requests,
      processed: processed,
      errors: errors,
      index: index,
      error: error,
      status: StateStatus.failure,
    );
  }

  @override
  List<Object?> get props => [
        inProcessRequest,
        processed,
        index,
        requests,
        errors,
        ...super.props,
      ];
}
