import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../widget.dart';

/// Parent model for all features of a widget in a travel document.
abstract class WidgetFeatureModel extends Model implements WidgetFeatureEntity {
  @override
  final String id;

  @override
  final int index;

  @override
  final WidgetFeatureType type;

  @override
  final Version version;

  /// Creates a new [WidgetFeatureModel] instance.
  WidgetFeatureModel({
    required this.id,
    required this.version,
    required this.type,
    required this.index,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        version,
        index,
        type,
      ];

  @override
  @mustCallSuper
  Map<String, dynamic> $toMap() => {
        'id': id,
        'type': type.toString(),
        'version': version.toString(),
        'index': index,
      };
}
