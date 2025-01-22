import '../../../repositories.dart';

/// Input to create a new widget folder.
typedef CreateWidgetFolderInput = ({
  TravelDocumentId travelDocumentId,
  String name,
  int? index,
  WidgetFolderIcon? icon,
  FeatureTextStyleColor? color,
});

/// Input to update an existing widget folder.
typedef UpdateWidgetFolderInput = ();
