import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../error/errors.dart';
import '../../../util/util.dart';
import '../../repositories.dart';

part '_travel_item_repository_impl.dart';

/// Repository for [TravelItemEntity].
///
/// This repository manages widgets and folders in a travel document.
abstract interface class TravelItemRepository extends RepositoryV3<String,
    TravelItemEntity, TravelItemRepositoryState, WError> {
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
  WFutureEither<UpsertWidgetOutput> createWidget({
    required WidgetModel widget,
    required int? index,
  });

  /// Creates a new widget folder.
  WFutureEither<UpsertWidgetFolderOutput> createFolder(
    CreateWidgetFolderInput input,
  );

  /// Updates an existing widget folder with the given [id].
  WFutureEither<UpsertWidgetFolderOutput> updateFolder({
    required String id,
    required TravelDocumentId travelDocumentId,
    required UpdateWidgetFolderInput input,
  });

  /// Deletes a widget or folder by its [id].
  WFutureEither<void> deleteItem(String id);

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
  WFutureEither<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  });

  /// Adds all [travelItems] into the repository without fetching them from the
  /// data source.
  ///
  /// This operation supports overriding existing items (with the same id).
  ///
  /// If [shouldEmit] is `false`, the repository will not emit a state change
  /// upon adding the travel items.
  WFutureEither<void> addAll({
    required Iterable<TravelItemEntityWrapper> travelItems,
    bool shouldEmit = true,
  });
}
