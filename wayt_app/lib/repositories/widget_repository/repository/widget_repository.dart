import 'package:a2f_sdk/a2f_sdk.dart';

import '../widget_repository.dart';

part '_widget_repository_impl.dart';
part 'widget_repository_state.dart';

abstract interface class WidgetRepository
    extends Repository<String, WidgetEntity, WidgetRepositoryState> {
  /// Creates a new instance of [WidgetRepository] that uses the provided data
  /// source.
  factory WidgetRepository(WidgetDataSource dataSource) =>
      _WidgetRepositoryImpl(dataSource);

  /// Creates a new Widget.
  Future<void> create(CreateWidgetInput input);

  /// Fetches all widget.
  Future<List<WidgetEntity>> fetchMany();

  /// Fetches a widget by its [id].
  Future<WidgetEntity> fetchOne(String id);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);

  /// Adds a widget to the repository without fetching it from the data source
  /// and without triggering a state change.
  /// 
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [addAll].
  void add(WidgetEntity widget, {bool shouldEmit = true});

  /// Adds multiple widgets to the repository without fetching them from the
  /// data source and without triggering a state change.
  /// 
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [add].
  void addAll(Iterable<WidgetEntity> widgets, {bool shouldEmit = true});
}
