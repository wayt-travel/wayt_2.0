import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

import 'widget_feature_type.dart';

abstract interface class WidgetFeatureEntity
    implements Equatable, UniquelyIdentifiableEntity {
  /// The index of the feature.
  int get index;

  /// The type of the feature.
  WidgetFeatureType get type;
}
