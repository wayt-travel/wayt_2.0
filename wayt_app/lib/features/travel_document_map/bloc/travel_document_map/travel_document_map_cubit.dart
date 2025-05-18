import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';

part 'travel_document_map_state.dart';

/// {@template travel_document_map_cubit}
/// Cubit for the travel document map.
///
/// This cubit is responsible for managing the state of the map and
/// handling the camera movements.
/// {@endtemplate}
class TravelDocumentMapCubit extends Cubit<TravelDocumentMapState> {
  /// The id of the travel document whose map is being displayed.
  final TravelDocumentId travelDocumentId;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document repository.
  final TravelDocumentRepository travelDocumentRepository;

  StreamSubscription<void>? _travelDocumentSubscription;

  /// {@macro travel_document_map_cubit}
  TravelDocumentMapCubit({
    required this.travelDocumentId,
    required this.travelItemRepository,
    required this.travelDocumentRepository,
  }) : super(const TravelDocumentMapInitial()) {
    _travelDocumentSubscription = travelItemRepository.listen((repoState) {
      // TravelItemRepoItemCollectionFetchSuccess state is not supported.
      if (repoState is TravelItemRepoItemCreateSuccess) {
        final travelItem = repoState.itemWrapper;
        if (travelItem.value.travelDocumentId != travelDocumentId ||
            travelItem.isFolderWidget) {
          // Ignore the item if it doesn't belong to the travel document or if
          // the item is a folder widget.
          return;
        }
        emit(TravelDocumentMapItemAdded(travelItem: travelItem.value));
      }
      if (repoState is TravelItemRepoItemDeleteSuccess) {
        final travelItem = repoState.itemWrapper;
        if (travelItem.value.travelDocumentId != travelDocumentId ||
            travelItem.isFolderWidget) {
          // Ignore the item if it doesn't belong to the travel document or if
          // the item is a folder widget.
          return;
        }
        emit(TravelDocumentMapItemRemoved(travelItem: travelItem.value));
      }
      if (repoState is TravelItemRepoItemUpdateSuccess) {
        final travelItem = repoState.updated;
        if (travelItem.value.travelDocumentId != travelDocumentId ||
            travelItem.isFolderWidget) {
          // Ignore the item if it doesn't belong to the travel document or if
          // the item is a folder widget.
          return;
        }
        emit(
          TravelDocumentMapItemUpdated(
            previous: repoState.previous.value,
            updated: travelItem.value,
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _travelDocumentSubscription?.cancel().ignore();
    return super.close();
  }

  /// Emits the [TravelDocumentMapInitialized] state that is meant to initialize
  /// the map camera (center and bounds) and the map features (pins, etc.).
  ///
  /// Call this method only when you're sure the travel document is fully loaded
  /// in the repository!
  Future<void> init() async {
    final td = TravelDocumentWrapper(
      travelDocument: travelDocumentRepository.getOrThrow(travelDocumentId.id),
      travelItems: travelItemRepository.getAllOf(travelDocumentId),
    );

    final allCoords =
        td.allFeatures.whereType<GeoWidgetFeatureEntity>().map((f) => f.latLng);

    final (:bounds, :center) = GeoUtils.computeBounds(allCoords);

    emit(
      TravelDocumentMapInitialized(
        centerOrBounds: Either.fromNullable(bounds, () => center),
        travelItems: td.onlyWidgets,
      ),
    );
  }
}
