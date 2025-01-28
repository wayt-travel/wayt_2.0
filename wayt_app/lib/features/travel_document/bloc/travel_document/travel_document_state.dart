part of 'travel_document_cubit.dart';

/// Common state for the travel document bloc.
sealed class TravelDocumentState<T extends TravelDocumentEntity>
    extends Equatable {
  const TravelDocumentState();

  @override
  List<Object?> get props => [];
}

/// Parent state for states that have travel document data, i.e., all states
/// except [TravelDocumentInitial] and the fetch in progress/failure states.
sealed class TravelDocumentStateWithData<T extends TravelDocumentEntity>
    extends TravelDocumentState<T> {
  /// The travel document entity.
  final TravelDocumentWrapper<T> wrapper;

  /// Creates a new instance of [TravelDocumentStateWithData].
  const TravelDocumentStateWithData(this.wrapper);

  @override
  List<Object?> get props => [wrapper];
}

/// Parent interface implemented by states that represent the fetch state.
abstract interface class TravelDocumentFetchState {}

/// The initial state of the travel document bloc.
final class TravelDocumentInitial<T extends TravelDocumentEntity>
    extends TravelDocumentState<T> {}

/// The state when the travel document is being fetched.
final class TravelDocumentFetchInProgress<T extends TravelDocumentEntity>
    extends TravelDocumentState<T> implements TravelDocumentFetchState {}

/// The state when the travel document fetch is successful
final class TravelDocumentFetchSuccess<T extends TravelDocumentEntity>
    extends TravelDocumentStateWithData<T> implements TravelDocumentFetchState {
  /// Creates a new instance of [TravelDocumentFetchSuccess].
  const TravelDocumentFetchSuccess(super.wrapper);
}

/// The state when the travel document fetch fails.
final class TravelDocumentFetchFailure<T extends TravelDocumentEntity>
    extends TravelDocumentState<T> implements TravelDocumentFetchState {
  /// Creates a new instance of [TravelDocumentFetchFailure].
  const TravelDocumentFetchFailure(this.error);

  /// The error that caused the fetch to fail.
  final WError error;

  @override
  List<Object?> get props => [error];
}

/// The state when the travel document item list is being updated.
final class TravelDocumentItemListUpdateSuccess<T extends TravelDocumentEntity>
    extends TravelDocumentStateWithData<T> {
  /// Creates a new instance of [TravelDocumentItemListUpdateSuccess].
  const TravelDocumentItemListUpdateSuccess(super.wrapper);
}

/// The state when the travel document summary is being updated.
final class TravelDocumentSummaryUpdateSuccess<T extends TravelDocumentEntity>
    extends TravelDocumentStateWithData<T> {
  /// Creates a new instance of [TravelDocumentSummaryUpdateSuccess].
  const TravelDocumentSummaryUpdateSuccess(super.wrapper);
}
