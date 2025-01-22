import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

part '_widget_repository_impl.dart';
part 'widget_repository_state.dart';

abstract interface class WidgetRepository
    extends Repository<String, WidgetEntity, WidgetRepositoryState> {
  /// Creates a new instance of [WidgetRepository].
  factory WidgetRepository({
    required TravelItemRepository travelItemRepository,
  }) =>
      _WidgetRepositoryImpl(travelItemRepository);

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
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);
}
