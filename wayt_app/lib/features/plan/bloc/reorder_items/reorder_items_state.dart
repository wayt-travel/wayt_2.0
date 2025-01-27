part of 'reorder_items_cubit.dart';

/// State for the [ReorderItemsCubit].
final class ReorderItemsState extends SuperBlocState<WError> {
  /// Whether the items are being reordered.
  final bool isReordering;

  const ReorderItemsState._({
    required this.isReordering,
    required super.status,
    super.error,
  });

  /// The initial state of the cubit.
  const ReorderItemsState.initial()
      : isReordering = false,
        super.initial();

  @override
  ReorderItemsState copyWith({
    required StateStatus status,
    bool? isReordering,
  }) =>
      ReorderItemsState._(
        isReordering: isReordering ?? this.isReordering,
        error: null,
        status: status,
      );

  @override
  ReorderItemsState copyWithError(WError error) => ReorderItemsState._(
        isReordering: isReordering,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        isReordering,
        ...super.props,
      ];
}
