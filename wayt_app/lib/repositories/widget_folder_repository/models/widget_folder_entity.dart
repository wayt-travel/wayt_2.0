import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

import '../../repositories.dart';

/// Entity for a folder of widgets in a travel plan or journal.
abstract interface class WidgetFolderEntity
    implements
        TravelItemEntity,
        Equatable,
        UniquelyIdentifiableEntity,
        ModelToStringMixin {
  /// The name of the folder.
  String get name;

  /// The icon of the folder.
  WidgetFolderIcon? get icon;

  /// The color of the folder.
  FeatureTextStyleColor? get color;
}
