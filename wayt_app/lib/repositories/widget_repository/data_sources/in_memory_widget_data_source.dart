import '../../../init/in_memory_data.dart';
import '../widget_repository.dart';

/// In-memory implementation of the Widget data source.
final class InMemoryWidgetDataSource implements WidgetDataSource {
  final InMemoryData _data;

  InMemoryWidgetDataSource(this._data);

  @override
  Future<WidgetModel> create(WidgetModel input) {
    _data.widgets.save(input.id, input);
    return Future.value(input);
  }

  @override
  Future<WidgetModel> read(String id) async => _data.widgets.getOrThrow(id);

  @override
  Future<void> delete(String id) {
    throw UnsupportedError(
      'In-memory data source does not support deleting Widget.',
    );
  }
}
