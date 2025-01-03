import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

part '_widget_repository_impl.dart';
part 'widget_repository_state.dart';

abstract interface class WidgetRepository
    extends Repository<String, WidgetEntity, WidgetRepositoryState> {
  /// Creates a new instance of [WidgetRepository] that uses the provided data
  /// source.
  factory WidgetRepository({
    required WidgetDataSource dataSource,
    required SummaryHelperRepository summaryHelperRepository,
  }) =>
      _WidgetRepositoryImpl(dataSource, summaryHelperRepository);

  /// Creates a new Widget at the given [index] in the plan or journal.
  ///
  /// The widget.order in model is disregarded as it will be recomputed using
  /// the provided [index] based on the existing widgets in the plan or journal.
  /// If [index] is `null`, the widget will be added at the end of the list.
  ///
  /// The response includes also a map of the widgets of the plan or journal
  /// whose order has been updated with the corresponding updated value.
  ///
  /// See [UpsertWidgetOutput].
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);

  /// Adds all [widgets] of [planOrJournalId] into the repository without
  /// fetching them from the data source.
  ///
  /// If [shouldEmit] is `false`, the repository will not emit a state change
  /// upon adding the widgets.
  void addAll({
    required PlanOrJournalId planOrJournalId,
    required Iterable<WidgetEntity> widgets,
    bool shouldEmit = true,
  });

  /// Gets all widgets of a plan with the given [planId] from the cache.
  List<WidgetEntity> getAllOfPlan(String planId);

  /// Gets all widgets of a journal with the given [journalId] from the cache.
  List<WidgetEntity> getAllOfJournal(String journalId);
}
