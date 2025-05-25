import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/core.dart';
import '../../features.dart';

/// {@template travel_document_map_widget}
/// A widget that displays the map of the travel document.
///
/// This widget can be used either in a flexible space or as a standalone
/// widget.
///
/// This widget requires the [TravelDocumentCubit] to be provided in the
/// widget tree.
/// {@endtemplate}
class TravelDocumentMapWidget extends StatelessWidget {
  /// {@macro travel_document_map_widget}
  const TravelDocumentMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelDocumentMapCubit(
        travelDocumentId: context.read<TravelDocumentCubit>().travelDocumentId,
        travelItemRepository: $.repo.travelItem(),
        travelDocumentRepository: $.repo.travelDocument(),
      ),
      child: BlocSelector<TravelDocumentCubit, TravelDocumentState, bool>(
        selector: (state) => state is TravelDocumentStateWithData,
        builder: (context, isLoaded) => _Map(
          key: ValueKey(isLoaded),
          isTravelDocumentLoaded: isLoaded,
        ),
      ),
    );
  }
}

class _Map extends StatefulWidget {
  final bool isTravelDocumentLoaded;

  const _Map({
    required this.isTravelDocumentLoaded,
    super.key,
  });

  @override
  State<_Map> createState() => __MapState();
}

class __MapState extends State<_Map> {
  late TravelDocumentMapManager manager;
  final _key = UniqueKey();

  Future<void> _onMapCreated(BuildContext context, MapboxMap mapboxMap) async {
    manager = await TravelDocumentMapManager.create(context, mapboxMap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the camera only if the travel document is loaded.
      if (context.mounted && widget.isTravelDocumentLoaded) {
        context.read<TravelDocumentMapCubit>().init().ignore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TravelDocumentMapCubit, TravelDocumentMapState>(
      listener: (context, state) {
        if (state is TravelDocumentMapInitialized) {
          manager.onInit(state);
        } else if (state is TravelDocumentMapItemAdded) {
          manager.onItemAdded(state.travelItem);
        } else if (state is TravelDocumentMapItemRemoved) {
          manager.onItemRemoved(state.travelItem);
        } else if (state is TravelDocumentMapItemUpdated) {
          manager.onItemUpdated(state.updated);
        }
      },
      child: MapWidget(
        key: _key,
        styleUri: MapboxStyles.SATELLITE_STREETS,
        onMapCreated: (mapboxMap) => _onMapCreated(context, mapboxMap),
        textureView: true,
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(41.8967, 12.4822),
          ),
          zoom: 1,
        ),
        gestureRecognizers: const {
          Factory<OneSequenceGestureRecognizer>(
            EagerGestureRecognizer.new,
          ),
        },
      ),
    );
  }
}
