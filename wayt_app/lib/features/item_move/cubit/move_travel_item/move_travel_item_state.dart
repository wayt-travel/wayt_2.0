part of 'move_travel_item_cubit.dart';

/// State of the [MoveTravelItemCubit].
final class MoveTravelItemState extends SuperBlocState<WError> {
  /// The ID of the folder where the travel items will be moved to.
  final String? destinationFolderId;

  const MoveTravelItemState._({
    required this.destinationFolderId,
    required super.status,
    super.error,
  });

  /// Creates an initial state of the [MoveTravelItemCubit].
  const MoveTravelItemState.initial({required this.destinationFolderId})
      : super.initial();

  @override
  MoveTravelItemState copyWith({
    required StateStatus status,
    Option<String?> destinationFolderId = const Option.none(),
  }) =>
      MoveTravelItemState._(
        destinationFolderId: destinationFolderId.getOrElse(
          () => this.destinationFolderId,
        ),
        error: error,
        status: status,
      );

  @override
  MoveTravelItemState copyWithError(WError error) => MoveTravelItemState._(
        destinationFolderId: destinationFolderId,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [destinationFolderId, ...super.props];
}
