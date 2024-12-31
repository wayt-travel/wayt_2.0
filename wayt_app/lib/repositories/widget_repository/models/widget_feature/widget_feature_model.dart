import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../widget_repository.dart';

abstract class WidgetFeatureModel extends Model implements WidgetFeatureEntity {
  @override
  final String id;

  @override
  final int index;

  @override
  final WidgetFeatureType type;

  @override
  final Version version;

  WidgetFeatureModel({
    required this.id,
    required this.version,
    required this.type,
    this.index = 0,
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
