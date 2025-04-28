import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/error.dart';
import '../../../../orchestration/orchestration.dart';
import '../../../../repositories/repositories.dart';

part 'move_travel_item_state.dart';

/// {@template move_travel_item_cubit}
/// Cubit to move travel items.
///
/// This cubit is used to move travel items:
/// - from a folder to another folder
/// - from a folder to the travel document root
/// - from the travel document root to a folder
/// {@endtemplate}
class MoveTravelItemCubit extends Cubit<MoveTravelItemState> with LoggerMixin {
  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The list of travel items to move.
  final List<TravelItemEntity> travelItemsToMove;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// {@macro move_travel_item_cubit}
  MoveTravelItemCubit({
    required String? initialDestinationFolderId,
    required this.travelDocumentId,
    required this.travelItemsToMove,
    required this.travelItemRepository,
    required this.travelDocumentLocalMediaDataSource,
  }) : super(
          MoveTravelItemState.initial(
            destinationFolderId: initialDestinationFolderId,
          ),
        );

  /// Changes the destination folder ID.
  void changeDestinationFolderId(String? destinationFolderId) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        destinationFolderId: Option.of(destinationFolderId),
      ),
    );
  }

  /// Moves the travel items to the new location.
  Future<void> submit() async {
    logger.d(
      'Submitting moving travel items '
      '${travelItemsToMove.map((e) => e.id).join(', ')} '
      'to folder ${state.destinationFolderId} in travel document '
      '$travelDocumentId',
    );
    emit(state.copyWith(status: StateStatus.progress));

    final either = await MoveTravelMediaOrchestrator(
      travelItemRepository: travelItemRepository,
      travelDocumentLocalMediaDataSource: travelDocumentLocalMediaDataSource,
      travelDocumentId: travelDocumentId,
      travelItemsToMove: travelItemsToMove,
      destinationFolderId: state.destinationFolderId,
    ).task().run();

    either.match(
      (error) => emit(state.copyWithError(error)),
      (_) => emit(state.copyWith(status: StateStatus.success)),
    );
  }
}
