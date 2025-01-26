part of 'delete_item_cubit.dart';

final class DeleteItemState extends SuperBlocState<WError> {
  const DeleteItemState._({
    required super.status,
    super.error,
  });

  const DeleteItemState.initial() : super.initial();

  @override
  DeleteItemState copyWith({required StateStatus status}) => DeleteItemState._(
        error: error,
        status: status,
      );

  @override
  DeleteItemState copyWithError(WError error) => DeleteItemState._(
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [...super.props];
}
