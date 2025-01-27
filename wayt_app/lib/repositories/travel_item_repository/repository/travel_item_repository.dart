import 'dart:async';
import 'dart:collection';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

part '_travel_item_repository_impl.dart';
part 'travel_item_repository_state.dart';

/// Repository for [TravelItemEntity].
///
/// This repository manages widgets and folders in a travel document.
abstract interface class TravelItemRepository
    extends Repository<String, TravelItemEntity, TravelItemRepositoryState> {
  /// Creates a new instance of [TravelItemRepository].
  factory TravelItemRepository({
    required SummaryHelperRepository summaryHelperRepository,
    required TravelItemDataSource travelItemDataSource,
    required WidgetDataSource widgetDataSource,
    required WidgetFolderDataSource widgetFolderDataSource,
  }) =>
      TravelItemRepositoryImpl(
        travelItemDataSource: travelItemDataSource,
        summaryHelperRepository: summaryHelperRepository,
        widgetDataSource: widgetDataSource,
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
  Future<void> deleteFolder(String id);

  /// Reorders the items in a travel document based on the provided
  /// [reorderedItemIds].
  ///
  /// This method supports reordering the items in the root of the travel
  /// document as well as the items contained in a folder. For the latter, the
  /// [folderId] should be provided.
  ///
  /// If [reorderedItemIds] does not match the list of items currently contained
  /// in the repo for the travel document with [travelDocumentId] the method
  /// will throw an [ArgumentError].
  Future<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  });

  /// Gets the travel item wrapper of the travel item with the given [id] from
  /// the cache.
  ///
  /// If the item is not found, [orElse] will be called and its result will be
  /// returned. If [orElse] is not provided, `null` will be returned.
  TravelItemEntityWrapper? getWrapped(
    String id, {
    TravelItemEntityWrapper Function()? orElse,
  });

  /// Gets the travel item wrapper of the travel item with the given [id] from
  /// the cache or throws an [ArgumentError] if the item is not found.
  TravelItemEntityWrapper getWrappedOrThrow(String id);

  /// Gets the travel item wrappers of the travel item with the given
  /// [travelDocumentId] from the cache.
  List<TravelItemEntityWrapper> getAllOf(TravelDocumentId travelDocumentId);

  /// Gets all the items (as wrappers) of a plan with the given [planId] from
  /// the cache.
  List<TravelItemEntityWrapper> getAllOfPlan(String planId);

  /// Gets all travel items (as wrappers) of a journal with the given
  /// [journalId] from the
  List<TravelItemEntityWrapper> getAllOfJournal(String journalId);

  /// Adds all [travelItems] of [travelDocumentId] into the repository without
  /// fetching them from the data source.
  ///
  /// This operation supports overriding existing items (with the same id).
  ///
  /// If [shouldEmit] is `false`, the repository will not emit a state change
  /// upon adding the travel items.
  void addAll({
    required TravelDocumentId travelDocumentId,
    required Iterable<TravelItemEntityWrapper> travelItems,
    bool shouldEmit = true,
  });
}
