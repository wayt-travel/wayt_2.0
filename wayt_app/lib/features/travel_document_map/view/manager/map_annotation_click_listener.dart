import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../features.dart';

/// {@template map_annotation_click_listener}
/// A listener for point annotation clicks of travel item pins on the map.
/// {@endtemplate}
class MapAnnotationClickListener extends OnPointAnnotationClickListener
    with LoggerMixin {
  /// The travel document map manager.
  ///
  /// It is mainly used to access the travel items.
  final TravelDocumentMapManager manager;

  /// {@macro map_annotation_click_listener}
  MapAnnotationClickListener(this.manager);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final item = manager.getTravelItemByAnnotationId(annotation.id);
    if (item == null) {
      logger.wtf(
        'Annotation with id ${annotation.id} not found in travel items',
      );
      return;
    }
  }
}
