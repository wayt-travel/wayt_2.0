part of 'delete_travel_document_cubit.dart';

/// State for the [DeleteTravelDocumentCubit].
final class DeleteTravelDocumentState extends SuperBlocState<WError> {
  const DeleteTravelDocumentState._({
    required super.status,
    super.error,
  });

  /// Initial state of the cubit.
  const DeleteTravelDocumentState.initial() : super.initial();

  @override
  DeleteTravelDocumentState copyWith({required StateStatus status}) {
    return DeleteTravelDocumentState._(
      status: status,
    );
  }

  @override
  DeleteTravelDocumentState copyWithError(WError error) {
    return DeleteTravelDocumentState._(
      status: StateStatus.failure,
      error: error,
    );
  }
}
