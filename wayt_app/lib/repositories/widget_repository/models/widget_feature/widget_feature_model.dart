import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/foundation.dart';

import '../../widget_repository.dart';

abstract class WidgetFeatureModel extends Model implements WidgetFeatureEntity {
  @override
  final String id;

  @override
  final int index;

  @override
  final WidgetFeatureType type;

  WidgetFeatureModel({
    required this.id,
    required this.index,
    required this.type,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        index,
        type,
      ];

  @override
  @mustCallSuper
  Map<String, dynamic> $toMap() => {
        'id': id,
        'index': index,
        'type': type.toString(),
      };
}
