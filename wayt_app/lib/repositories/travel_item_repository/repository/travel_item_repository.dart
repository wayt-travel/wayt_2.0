import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

part '_travel_item_repository_impl.dart';
part 'travel_item_repository_state.dart';

/// Facade repository for [TravelItemEntity].
///
/// This repository does not manage its entities directly, it listens to
/// widget and folder repositories and emit states accordingly.
abstract interface class TravelItemRepository
    extends Repository<String, TravelItemEntity, TravelItemRepositoryState> {
  /// Creates a new instance of [TravelItemRepository].
  factory TravelItemRepository({
    required WidgetRepository widgetRepository,
  }) =>
      _TravelItemRepositoryImpl(widgetRepository: widgetRepository);

  /// Gets all travel items of a plan with the given [planId] from the cache.
  List<TravelItemEntity> getAllOfPlan(String planId);

  /// Gets all travel items of a journal with the given [journalId] from the
  List<TravelItemEntity> getAllOfJournal(String journalId);
}
