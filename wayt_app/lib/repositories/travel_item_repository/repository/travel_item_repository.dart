import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flext/flext.dart';

import '../../../util/util.dart';
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
    required SummaryHelperRepository summaryHelperRepository,
    required WidgetRepository widgetRepository,
    required WidgetDataSource widgetDataSource,
    required WidgetFolderRepository widgetFolderRepository,
    required WidgetFolderDataSource widgetFolderDataSource,
  }) =>
      _TravelItemRepositoryImpl(
        summaryHelperRepository: summaryHelperRepository,
        widgetRepository: widgetRepository,
        widgetDataSource: widgetDataSource,
        widgetFolderRepository: widgetFolderRepository,
        widgetFolderDataSource: widgetFolderDataSource,
      );

  /// Creates a new Widget at the given [index] in the plan or journal.
  ///
  /// The widget.order in model is disregarded as it will be recomputed using
  /// the provided [index] based on the existing widgets in the plan or journal.
  /// If [index] is `null`, the widget will be added at the end of the list.
  /// If [index] is out of bounds, the widget will be added at the end of the
  /// list.
  ///
  /// The response includes also a map of the widgets of the plan or journal
  /// whose order has been updated with the corresponding updated value.
  ///
  /// See [UpsertWidgetOutput].
  Future<UpsertWidgetOutput> createWidget(WidgetModel widget, int? index);

  /// Creates a new widget folder.
  Future<UpsertWidgetFolderOutput> createFolder(CreateWidgetFolderInput input);

  /// Deletes a widget by its [id].
  Future<void> deleteWidget(String id);

  /// Deletes a folder by its [id].
  ///
  /// If [deleteContent] is `true`, all the travel items of the folder will be
  /// deleted as well, otherwise they will be moved inside the travel document
  /// that contains the folder at the index of the folder.
  Future<void> deleteFolder({
    required String id,
    required bool deleteContent,
  });

  /// Gets all travel items of a plan with the given [planId] from the cache.
  List<TravelItemEntity> getAllOfPlan(String planId);

  /// Gets all travel items of a journal with the given [journalId] from the
  List<TravelItemEntity> getAllOfJournal(String journalId);

  /// Adds all [travelItems] of [travelDocumentId] into the repository without
  /// fetching them from the data source.
  ///
  /// If [shouldEmit] is `false`, the repository will not emit a state change
  /// upon adding the travel items.
  void addAll({
    required TravelDocumentId travelDocumentId,
    required Iterable<TravelItemEntity> travelItems,
    bool shouldEmit = true,
  });
}
