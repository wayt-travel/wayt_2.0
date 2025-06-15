import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../../core/core.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../../util/util.dart';

final _logger = NthLogger('$LatLngPicker');

/// {@template lat_lng_picker}
/// A fullscreen dialog that allows the user to select a latitude and
/// longitude on a map.
/// {@endtemplate}
class LatLngPicker extends StatefulWidget {
  /// {@template lat_lng_picker_initial_lat_lng}
  /// [initialLatLng] is he initial latitude and longitude to center the map on.
  ///
  /// If `null`, the map will be centered on (0, 0).
  /// {@endtemplate}
  final LatLng initialLatLng;

  /// {@template lat_lng_picker_initial_zoom}
  /// [initialZoom] is the initial zoom level of the map.
  /// {@endtemplate}
  final double initialZoom;

  const LatLngPicker._({
    required LatLng? initialLatLng,
    required this.initialZoom,
  }) : initialLatLng = initialLatLng ?? const LatLng(0, 0);

  /// Shows the LatLngPicker modal.
  ///
  /// {@macro lat_lng_picker}
  ///
  /// [initialLatLng] is he initial latitude and longitude to center the map on.
  ///
  /// {@macro lat_lng_picker_initial_zoom}
  static Future<LatLng?> show({
    required BuildContext context,
    required LatLng initialLatLng,
    required double initialZoom,
  }) =>
      context.navRoot.push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => LatLngPicker._(
            initialLatLng: initialLatLng,
            initialZoom: initialZoom,
          ),
        ),
      );

  /// Shows the LatLngPicker modal for a travel document.
  ///
  /// {@macro lat_lng_picker}
  ///
  /// [travelDocumentId] is the id of the travel document to get the initial
  /// latitude and longitude from. The coordinates where the picker will be
  /// centered are the last coordinates found in the travel document (among all
  /// the [GeoWidgetFeatureEntity] features sorted by widget's createdAt).
  /// If no coordinates are found, the map will be centered on (0, 0).
  static Future<LatLng?> showForTravelDocument({
    required BuildContext context,
    required TravelDocumentId travelDocumentId,
  }) {
    final initialLatLng = $.repo
        .travelItem()
        .getAllOf(travelDocumentId)
        .expand((el) => el.allWidgets)
        .sortedBy((el) => el.createdAt)
        .expand((widget) => widget.features)
        .whereType<GeoWidgetFeatureEntity>()
        .lastOrNull
        ?.latLng;
    return context.navRoot.push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => LatLngPicker._(
          initialLatLng: initialLatLng,
          initialZoom: initialLatLng != null ? 4 : 0,
        ),
      ),
    );
  }

  @override
  State<LatLngPicker> createState() => _LatLngPickerState();
}

class _LatLngPickerState extends State<LatLngPicker> {
  MapboxMap? mapboxMap;
  late LatLng target;
  var _prettifyLatLng = true;

  @override
  void initState() {
    super.initState();
    target = widget.initialLatLng;
    _logger.d(
      'Launching LatLngPicker with initialLatLng=$target and '
      'initialZoom=${widget.initialZoom}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => setState(() {
            _prettifyLatLng = !_prettifyLatLng;
          }),
          child: Text(
            _prettifyLatLng ? target.toPrettyString() : target.toShortString(),
            style: context.tt.titleSmall,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => context.navRoot.pop(target),
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: (mapboxMap) async {
              this.mapboxMap = mapboxMap;
              // TODO: use permission handler to ask for location permissions
              await mapboxMap.location.updateSettings(
                LocationComponentSettings(
                  enabled: true,
                  pulsingEnabled: true,
                ),
              );
              final cameraOptions = CameraOptions(
                center: widget.initialLatLng.toPoint(),
                zoom: widget.initialZoom,
              );
              await mapboxMap.setCamera(cameraOptions);
            },
            styleUri: MapboxStyles.SATELLITE_STREETS,
            onCameraChangeListener: (data) async {
              setState(() {
                target = data.cameraState.center.toLatLng();
              });
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: const Icon(
                Icons.place,
                size: 48,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 8,
                  ),
                ],
                // color: context.col.primary,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
