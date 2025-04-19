part of 'create_photo_widget_cubit.dart';

/// State of the [CreatePhotoWidgetCubit].
final class CreatePhotoWidgetState extends SuperBlocState<WError> {
  /// List of photo requests to be processed.
  final List<XFile> requests;

  /// List of processed photo requests.
  final List<PhotoWidgetModel> processed;

  /// List of errors that occurred during processing.
  final List<({XFile file, WError error})> errors;

  /// The index of the current request being processed.
  final int index;

  /// The current request being processed.
  dynamic get inProcessRequest =>
      index.isBetween(0, requests.length - 1) ? requests[index] : null;

  const CreatePhotoWidgetState._({
    required this.requests,
    required this.processed,
    required this.errors,
    required this.index,
    required super.status,
    super.error,
  });

  /// The initial state of the [CreatePhotoWidgetCubit].
  const CreatePhotoWidgetState.initial()
      : requests = const [],
        processed = const [],
        errors = const [],
        index = -1,
        super.initial();

  @override
  CreatePhotoWidgetState copyWith({
    required StateStatus status,
    List<XFile>? requests,
    List<PhotoWidgetModel>? processed,
    List<({XFile file, WError error})>? errors,
    int? index,
  }) =>
      CreatePhotoWidgetState._(
        requests: requests ?? this.requests,
        processed: processed ?? this.processed,
        errors: errors ?? this.errors,
        index: index ?? this.index,
        error: error,
        status: status,
      );

  @override
  CreatePhotoWidgetState copyWithError(WError error) =>
      CreatePhotoWidgetState._(
        requests: requests,
        processed: processed,
        errors: errors,
        index: index,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        inProcessRequest,
        requests,
        processed,
        errors,
        index,
        ...super.props,
      ];
}
