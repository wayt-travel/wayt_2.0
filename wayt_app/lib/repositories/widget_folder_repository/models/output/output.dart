import '../../../repositories.dart';

/// Returns a record where `widgetFolder` is the created/updated folder and
/// the `updatedOrders` is a map where th `key` is the uuid of the item and the
/// `value` is its order in the folder.
typedef UpsertWidgetFolderOutput = ({
  WidgetFolderModel widgetFolder,
  Map<String, int> updatedOrders,
});
