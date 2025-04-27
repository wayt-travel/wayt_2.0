import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';

part 'reorder_items_state.dart';

/// Cubit for reordering items in a travel document.
class ReorderItemsCubit extends Cubit<ReorderItemsState> with LoggerMixin {
  /// The ID of the travel document containing the items to reorder.
  final TravelDocumentId travelDocumentId;

  /// The ID of the folder containing the items to reorder.
  ///
  /// If `null`, the items are at the root of the travel document.
  final String? folderId;

  /// The repository for travel items.
  final TravelItemRepository travelItemRepository;

  /// Creates a new instance of [ReorderItemsCubit].
  ReorderItemsCubit({
    required this.travelDocumentId,
    required this.travelItemRepository,
    this.folderId,
  }) : super(const ReorderItemsState.initial());

  /// Whether the items are being reordered.
  bool get isReordering => state.isReordering;

  /// Toggles the reordering.
  void toggleReordering({required bool isReordering}) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        isReordering: isReordering,
      ),
    );
  }

  /// Saves the reordered items.
  ///
  /// [reorderedItemIds] is the list of the IDs of the items in the new order.
  Future<void> save(List<String> reorderedItemIds) async {
    logger.v(
      'Starting logic to save ${reorderedItemIds.length} reordered items',
    );
    if (!isReordering) {
      logger.wtf(
        'Reordering is not enabled! How come we are saving an order update!? '
        'We continue anyway... but this is a bug!',
      );
    }
    emit(
      state.copyWith(status: StateStatus.progress),
    );

    final either = await travelItemRepository.reorderItems(
      travelDocumentId: travelDocumentId,
      folderId: folderId,
      reorderedItemIds: reorderedItemIds,
    ).run();

    either.match(
      (error) {
        logger.e('Error saving reordered items: $error');
        emit(state.copyWithError(error));
      },
      (_) {
        logger.i('Reordered items saved successfully');
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
}
