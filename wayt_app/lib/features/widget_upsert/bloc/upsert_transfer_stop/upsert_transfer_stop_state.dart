part of 'upsert_transfer_stop_cubit.dart';

/// The state of the [UpsertTransferStopCubit].
final class UpsertTransferStopState extends SuperBlocState<WError> {
  /// The name of the stop.
  final String name;

  /// The address of the stop.
  final String? address;

  /// The latitude coordinate of the stop.
  final double? lat;

  /// The longitude coordinate of the stop.
  final double? lng;

  /// The timestamp of the stop.
  ///
  /// It is the time when the stop is reached.
  final DateTime? dateTime;

  const UpsertTransferStopState._({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.dateTime,
    required super.status,
    super.error,
  });

  /// Creates a new [UpsertTransferStopState] instance with default initial
  /// values.
  UpsertTransferStopState.initial(TransferStop? other)
      : name = other?.name ?? '',
        address = other?.address,
        lat = other?.latLng.latitude,
        lng = other?.latLng.longitude,
        dateTime = other?.dateTime,
        super.initial();

  @override
  UpsertTransferStopState copyWith({
    required StateStatus status,
    String? name,
    Option<String?> address = const None(),
    Option<double?> lat = const None(),
    Option<double?> lng = const None(),
    Option<DateTime?> dateTime = const None(),
  }) =>
      UpsertTransferStopState._(
        name: name ?? this.name,
        address: address.getOr(this.address),
        lat: lat.getOr(this.lat),
        lng: lng.getOr(this.lng),
        dateTime: dateTime.getOr(this.dateTime),
        error: error,
        status: status,
      );

  @override
  UpsertTransferStopState copyWithError(WError error) =>
      UpsertTransferStopState._(
        name: name,
        address: address,
        lat: lat,
        lng: lng,
        dateTime: dateTime,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        name,
        address,
        lat,
        lng,
        dateTime,
        ...super.props,
      ];
}
