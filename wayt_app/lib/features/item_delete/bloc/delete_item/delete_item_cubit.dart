import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/errors.dart';
import '../../../../repositories/repositories.dart';

part 'delete_item_state.dart';

/// Cubit to be used one-off to delete a travel item, meaning, when you need
/// to delete a travel item, you create an instance of this cubit, call the
/// `delete` method and then dispose of it.
class DeleteItemCubit extends Cubit<DeleteItemState> with LoggerMixin {
  /// The item to be deleted.
  final TravelItemEntity item;

  /// The travel item repository.
  final TravelItemRepository repository;

  /// Creates a new instance of [DeleteItemCubit].
  DeleteItemCubit({
    required this.item,
    required this.repository,
  }) : super(const DeleteItemState.initial());

  /// Runs the delete operation.
  Future<void> delete() async {
    logger.v('Deleting item $item');
    emit(state.copyWith(status: StateStatus.progress));
    try {
      if (item.isFolderWidget) {
        await repository.deleteFolder(item.id);
      } else {
        await repository.deleteWidget(item.id);
      }
      logger.i('Item $item deleted successfully');
      emit(state.copyWith(status: StateStatus.success));
    } catch (e, s) {
      logger.e('Error deleting item $item', e, s);
      emit(state.copyWithError(e.errorOrGeneric));
      return;
    }
  }
}
