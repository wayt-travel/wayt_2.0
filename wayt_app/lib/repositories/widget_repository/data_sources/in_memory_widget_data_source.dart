import 'package:flext/flext.dart';

import '../../../init/in_memory_data.dart';
import '../widget_repository.dart';

/// In-memory implementation of the Widget data source.
final class InMemoryWidgetDataSource implements WidgetDataSource {
  final InMemoryData _data;

  InMemoryWidgetDataSource(this._data);

  @override
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index) {
    // Get the widgets of the plan or journal and insert the widget at the
    // specified index.
    var widgets = _data.getWidgetsOfPlanOrJournal(widget.planOrJournalId);
    if (index != null) {
      widgets.insert(index, widget);
    } else {
      widgets.add(widget);
    }

    // Recompute the order of the widgets after the insertion.
    widgets = widgets
        .mapIndexed((i, w) => w.order != i ? w.copyWith(order: i) : w)
        .toList();

    // Save the updated widgets.
    _data.widgets.saveAll({
      for (final widget in widgets) widget.id: widget,
    });

    // Get the list of widgets whose order was updated.
    final updatedWidgets = index != null && widgets.length > index
        ? widgets.sublist(index + 1)
        : <WidgetModel>[];

    // Build the output.
    return Future.value(
      (
        widget: _data.widgets.getOrThrow(widget.id),
        updatedOrders: {
          for (final widget in updatedWidgets) widget.id: widget.order,
        },
      ),
    );
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
