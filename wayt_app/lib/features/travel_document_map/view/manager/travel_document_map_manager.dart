import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';
import '../../../features.dart';

/// {@template travel_document_map_manager}
/// A class that manages the state of the travel document map.
///
/// It is responsible for camera movements, setting up the map, and managing
/// the annotations.
/// {@endtemplate}
class TravelDocumentMapManager {
  /// The mapbox map instance obtained from the map widget `onMapCreated`
  /// callback.
  final MapboxMap mapboxMap;

  /// The point annotation manager instance for the travel document pins.
  final PointAnnotationManager pointAnnotationManager;

  /// The polyline annotation manager instance for the travel document
  /// polylines.
  final PolylineAnnotationManager polylineAnnotationManager;

  /// Maps the id of each annotation on the map to the corresponding
  /// [TravelItemEntity] object.
  Map<PointAnnotation, TravelItemEntity> _pointsAnnotationsToItems = {};
  Map<PolylineAnnotation, TravelItemEntity> _polylineAnnotationsToItems = {};

  /// A map that stores the loaded icon assets for each pin.
  ///
  /// It allows to avoid loading the same asset multiple times.
  final Map<String, Uint8List> icons = {};

  /// The default animation options for the map.
  static final _defaultAnimationOptions = MapAnimationOptions(duration: 1000);

  /// The default camera padding for the map.
  final MbxEdgeInsets cameraPadding;

  TravelDocumentMapManager._({
    required this.mapboxMap,
    required this.pointAnnotationManager,
    required this.polylineAnnotationManager,
    required this.cameraPadding,
  });

  /// Creates a new instance of [TravelDocumentMapManager].
  ///
  /// {@macro travel_document_map_manager}
  static Future<TravelDocumentMapManager> create(
    BuildContext context,
    MapboxMap mapboxMap,
  ) async {
    final polylineAnnotationManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    final pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    // Quite improbable that the context is not mounted, but just in case...
    final h = context.mounted ? context.heightPx : 300;
    final w = context.mounted ? context.widthPx : 200;
    final instance = TravelDocumentMapManager._(
      mapboxMap: mapboxMap,
      polylineAnnotationManager: polylineAnnotationManager,
      pointAnnotationManager: pointAnnotationManager,
      // The numbers below are a bit random, we may want to adjust them in the
      // future.
      cameraPadding: MbxEdgeInsets(
        top: h * .35,
        left: w * .12,
        bottom: h * .2,
        right: w * .12,
      ),
    );
    await instance._init();
    return instance;
  }

  /// Initialized the map from the given [state].
  ///
  /// It sets the annotations and moves the camera to the given center or bounds
  /// provided in the [state].
  Future<void> onInit(TravelDocumentMapInitialized state) async {
    await _setAnnotations(state.travelItems);
    await _moveCamera(state.centerOrBounds);
  }

  /// Parses the given [travelItem] to add its annotations to the map.
  Future<void> onItemAdded(TravelItemEntity travelItem) async {
    await _addAnnotations([travelItem]);
  }

  /// Parses the given [travelItem] to update its annotations on the map.
  Future<void> onItemUpdated(TravelItemEntity travelItem) async {
    await _removeAnnotationsOfItem(travelItem.id);
    await _addAnnotations([travelItem]);
  }

  /// Removes the annotations of the given [travelItem] from the map.
  Future<void> onItemRemoved(TravelItemEntity travelItem) async {
    await _removeAnnotationsOfItem(travelItem.id);
  }

  /// Gets the travel item associated with the given annotation id.
  TravelItemEntity? getTravelItemByAnnotationId(String id) {
    return _pointsAnnotationsToItems.entries
            .firstWhereOrNull((e) => e.key.id == id)
            ?.value ??
        _polylineAnnotationsToItems.entries
            .firstWhereOrNull((e) => e.key.id == id)
            ?.value;
  }

  Future<void> _init() async {
    // Remove the scale bar from the map.
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    // await mapboxMap.attribution.updateSettings(
    //   AttributionSettings(enabled: false),
    // );

    // Add the click listener to the point annotation manager.
    pointAnnotationManager
        .addOnPointAnnotationClickListener(MapAnnotationClickListener(this));

    // polylineAnnotationManager.addOnPolylineAnnotationClickListener(
    //   MapAnnotationClickListener(this),
    // );
  }

  /// Loads, caches and returns the icon for the given [TravelDocumentMapPin]
  /// to be used as a pin on the map.
  Future<Uint8List> _getIconForPin(TravelDocumentMapPin pin) async {
    final assetPath = pin.assetPath;
    if (!icons.containsKey(assetPath)) {
      final bytes = await rootBundle.load(assetPath);
      final imageData = bytes.buffer.asUint8List();
      icons[assetPath] = imageData;
    }
    return icons[assetPath]!;
  }

  /// Loads, caches and returns the icon for the given [TravelItemEntity]
  /// to be used as a pin on the map.
  Future<Uint8List> _getIconForItem(TravelItemEntity item) =>
      _getIconForPin(TravelDocumentMapPin.fromItem(item));

  /// Builds the annotations for the given [TravelItemEntity].
  ///
  /// Each item can return more than one annotation, for example, a transfer
  /// item will return an annotation for each stop + a polyline connecting them.
  Future<List<Either<PointAnnotationOptions, PolylineAnnotationOptions>>>
      _buildPointOptionForItem(
    TravelItemEntity item,
  ) async {
    if (item is PhotoWidgetModel && item.latLng != null) {
      return [
        Either.left(
          PointAnnotationOptions(
            geometry: item.latLng!.toPoint(),
            image: await _getIconForItem(item),
          ),
        ),
      ];
    } else if (item is PlaceWidgetModel) {
      return [
        Either.left(
          PointAnnotationOptions(
            geometry: item.latLng.toPoint(),
            image: await _getIconForItem(item),
            iconAnchor: IconAnchor.BOTTOM,
          ),
        ),
      ];
    } else if (item is TransferWidgetModel) {
      return [
        for (final stop in item.stops)
          Either.left(
            PointAnnotationOptions(
              geometry: stop.latLng.toPoint(),
              image: await _getIconForItem(item),
              iconAnchor: IconAnchor.BOTTOM,
            ),
          ),
        Either.right(
          PolylineAnnotationOptions(
            geometry: LineString.fromPoints(
              points: item.stops.map((e) => e.latLng.toPoint()).toList(),
            ),
            // FIXME: use toARGB32() when upgrading flutter version
            lineColor: Colors.red.value,
            lineWidth: 5,
          ),
        ),
      ];
    }
    return const [];
  }

  Future<void> _removeAnnotationsOfItem(String itemId) => Future.wait(
        [
          ..._pointsAnnotationsToItems.entries
              .where((e) => e.value.id == itemId)
              .map((e) => e.key)
              .toList()
              .map((point) {
            _pointsAnnotationsToItems.remove(point);
            return pointAnnotationManager.delete(point);
          }),
          ..._polylineAnnotationsToItems.entries
              .where((e) => e.value.id == itemId)
              .map((e) => e.key)
              .toList()
              .map((polyline) {
            _polylineAnnotationsToItems.remove(polyline);
            return polylineAnnotationManager.delete(polyline);
          }),
        ],
      );

  /// For each travel item in the given [travelItems], builds the annotations
  /// to be added on the map and adds them to the map.
  Future<void> _addAnnotations(Iterable<TravelItemEntity> travelItems) async {
    final options = <TravelItemEntity,
        List<Either<PointAnnotationOptions, PolylineAnnotationOptions>>>{};

    for (final travelItem in travelItems) {
      final option = await _buildPointOptionForItem(travelItem);
      if (option.isNotEmpty) {
        options[travelItem] = option;
      }
    }

    if (options.isNotEmpty) {
      final pointOptions = options.entries
          .expand((e) => e.value.map((v) => MapEntry(e.key, v)))
          .where((e) => e.value.isLeft())
          .map((e) => MapEntry(e.key, e.value.getLeftOrThrow()))
          .toList();

      if (pointOptions.isNotEmpty) {
        await pointAnnotationManager
            .createMulti(pointOptions.map((e) => e.value).toList())
            .then((points) {
          _pointsAnnotationsToItems.addAll(
            Map.fromIterables(
              points.nonNulls,
              pointOptions.map((e) => e.key),
            ),
          );
        });
      }

      final polylineOptions = options.entries
          .expand((e) => e.value.map((v) => MapEntry(e.key, v)))
          .where((e) => e.value.isRight())
          .map((e) => MapEntry(e.key, e.value.getRightOrThrow()))
          .toList();

      if (polylineOptions.isNotEmpty) {
        await polylineAnnotationManager
            .createMulti(polylineOptions.map((e) => e.value).toList())
            .then((polyline) {
          _polylineAnnotationsToItems.addAll(
            Map.fromIterables(
              polyline.nonNulls,
              polylineOptions.map((e) => e.key),
            ),
          );
        });
      }
    }
  }

  /// Deletes all the annotations on the map and adds new ones for the
  /// given [travelItems].
  Future<void> _setAnnotations(List<TravelItemEntity> travelItems) async {
    await pointAnnotationManager.deleteAll();
    await polylineAnnotationManager.deleteAll();
    _pointsAnnotationsToItems = {};
    _polylineAnnotationsToItems = {};
    await _addAnnotations(travelItems);
  }

  /// Moves the camera to the given [centerOrBounds].
  ///
  /// If the [centerOrBounds] is [Left], it moves the camera to the given
  /// [LatLng] coordinate.
  ///
  /// If the [centerOrBounds] is [Right], it moves the camera in order to fit
  /// the given [LatLngBounds] in the map.
  Future<void> _moveCamera(Either<LatLng, LatLngBounds> centerOrBounds) {
    return centerOrBounds.match(
      (center) => mapboxMap.easeTo(
        CameraOptions(center: center.toPoint()),
        _defaultAnimationOptions,
      ),
      (bounds) => mapboxMap
          .cameraForCoordinateBounds(
            CoordinateBounds(
              southwest: bounds.southwest.toPoint(),
              northeast: bounds.northeast.toPoint(),
              infiniteBounds: false,
            ),
            cameraPadding,
            null,
            null,
            null,
            null,
          )
          .then(
            (options) => mapboxMap.easeTo(options, _defaultAnimationOptions),
          ),
    );
  }
}
