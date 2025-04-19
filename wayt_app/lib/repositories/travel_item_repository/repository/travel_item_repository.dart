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
abstract interface class TravelItemRepository extends RepositoryV2<
    String,
    TravelItemEntity,
    TravelItemRepositoryEvent,
    TravelItemRepositoryState,
    WError> {
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

  /// Creates a new widget by calling [addSequentialAndWait] adding a
  /// [TravelItemRepoWidgetCreatedEvent].
  WTaskEither<UpsertWidgetOutput> createWidget(WidgetModel widget, int? index);

  /// Creates a new widget folder by calling [addSequentialAndWait] adding a
  /// [TravelItemRepoFolderCreatedEvent].
  WTaskEither<UpsertWidgetFolderOutput> createFolder(
    CreateWidgetFolderInput input,
  );

  /// Updates an existing widget folder by calling [addSequentialAndWait] adding
  /// a [TravelItemRepoFolderCreatedEvent].
  WTaskEither<UpsertWidgetFolderOutput> updateFolder(
    String id, {
    required TravelDocumentId travelDocumentId,
    required UpdateWidgetFolderInput input,
  });

  /// Deletes a widget or folder by its [id] by calling [addSequentialAndWait]
  /// adding a [TravelItemRepoItemDeletedEvent].
  WTaskEither<void> deleteItem(String id);

  /// Reorders the items in a travel document by calling [addSequentialAndWait]
  /// adding a [TravelItemRepoItemsReorderedEvent].
  WTaskEither<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  });

  /// Adds [travelItems] by calling [addSequentialAndWait] adding a
  /// [TravelItemRepoItemsAddedEvent].
  WTaskEither<void> addAll({
    required Iterable<TravelItemEntityWrapper> travelItems,
    bool shouldEmit = true,
  });
}
