part of '../../widget_model.gen.dart';

/// {@template transfer_widget_model}
/// A widget that represents a transfer by a means of transport
/// [meansOfTransport].
///
/// This widget can be used to display a transfer in the travel document. At
/// least 2 [stops] are required: the starting and ending stops.
///
/// When defining the [stops], the first stop is the starting point of the
/// transfer, and the last stop is the ending point. Other stops in between are
/// considered intermediate stops.
///
/// When setting the date-time of stops, the chronological order must be
/// respected, in fact each stop may have:
/// - `null` date-time
/// - a date-time that is greater than or equal all the previous stops date-time
///   and less than or equal to all the next stops date-time (null date-times
///   are ignored in the comparison).
///
/// The [id] uniquely identifies the widget.
///
/// The [order] is the order of the widget in the travel document.
///
/// The [travelDocumentId] is the ID of the travel document to which the widget
/// belongs.
///
/// The [folderId] is the ID of the folder where the widget is stored. If null,
/// the widget is stored in the root of the travel document.
///
/// The [createdAt] is the date and time when the widget was created. If null,
/// the current date and time is used.
///
/// The [updatedAt] is the date and time when the widget was last updated. If
/// null, the widget has not been updated yet.
/// {@endtemplate}
final class TransferWidgetModel extends WidgetModel {
  /// {@macro transfer_widget_model}
  factory TransferWidgetModel({
    required String id,
    required int order,
    required TravelDocumentId travelDocumentId,
    required List<TransferStop> stops,
    required MeansOfTransportType meansOfTransport,
    String? folderId,
    DateTime? createdAt,
  }) =>
      TransferWidgetModel._(
        id: id,
        order: order,
        features: [
          MeansOfTransportWidgetFeatureModel(
            id: const Uuid().v4(),
            motType: meansOfTransport,
          ),
          ...stops.map((stop) => stop.toGeoWidgetFeature()),
        ],
        folderId: folderId,
        createdAt: createdAt ?? DateTime.now().toUtc(),
        travelDocumentId: travelDocumentId,
        updatedAt: null,
      );

  TransferWidgetModel._({
    required super.id,
    required super.order,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  })  : assert(
          features.length >= 3,
          'Transfer widget must have at least 3 features: start, end, and '
          'means of transport.',
        ),
        super(
          type: WidgetType.transfer,
          version: Version(1, 0, 0),
        ) {
    final stops = _stopFeatures;
    assert(
      stops.length >= 2,
      'Transfer widget must have at least 2 stops: start and end.',
    );
    final timeSequenceWithNulls = stops.map((f) => f.timestamp).toList();
    final timeSequence = timeSequenceWithNulls.nonNulls.toList();
    assert(
      listEquals(
        timeSequence,
        timeSequence.sorted(),
      ),
      'The stops must be in chronological order '
      '{stop times: '
      '${timeSequenceWithNulls.map((e) => e?.toIso8601String()).join(', ')}}',
    );
    // Calling the getter to ensure that the means of transport feature is
    // present.
    // This will throw an error if the feature is not present.
    _motFeature;
  }

  /// The means of transport used for the transfer.
  MeansOfTransportType get meansOfTransport => _motFeature.motType;

  /// The starting stop of the transfer.
  TransferStop get startingStop =>
      TransferStop.fromGeoWidgetFeature(_stopFeatures.first);

  /// The ending stop of the transfer.
  TransferStop get endingStop =>
      TransferStop.fromGeoWidgetFeature(_stopFeatures.last);

  /// The intermediate stops of the transfer.
  ///
  /// This list is empty if there are no intermediate stops.
  List<TransferStop> get intermediateStops => _stopFeatures.length <= 2
      ? []
      : _stopFeatures
          .sublist(1, _stopFeatures.length - 1)
          .map(TransferStop.fromGeoWidgetFeature)
          .toList();

  /// All stops of the transfer, including starting and ending stops.
  List<TransferStop> get stops =>
      _stopFeatures.map(TransferStop.fromGeoWidgetFeature).toList();

  MeansOfTransportWidgetFeatureModel get _motFeature => features.singleWhere(
        (feature) => feature is MeansOfTransportWidgetFeatureModel,
        orElse: () => throw ArgumentError('Means of transport not found'),
      ) as MeansOfTransportWidgetFeatureModel;

  List<GeoWidgetFeatureModel> get _stopFeatures =>
      features.whereType<GeoWidgetFeatureModel>().toList();

  @override
  WidgetModel copyWith({
    Option<String?> folderId = const Option.none(),
    int? order,
    DateTime? updatedAt,
    List<TransferStop>? stops,
    MeansOfTransportType? meansOfTransport,
  }) =>
      TransferWidgetModel._(
        id: id,
        order: order ?? this.order,
        features: [
          _motFeature.copyWith(
            motType: meansOfTransport ?? this.meansOfTransport,
          ),
          ...(stops?.map((stop) => stop.toGeoWidgetFeature()) ?? _stopFeatures),
        ],
        folderId: folderId.getOr(this.folderId),
        createdAt: createdAt,
        travelDocumentId: travelDocumentId,
        updatedAt: updatedAt ?? DateTime.now().toUtc(),
      );
}
