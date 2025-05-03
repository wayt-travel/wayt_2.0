part of 'upsert_place_widget_cubit.dart';

/// State of the [UpsertPlaceWidgetCubit].
final class UpsertPlaceWidgetState extends SuperBlocState<WError> {
  /// The latitude of the location.
  final double? lat;

  /// The latitude of the location.
  final double? lng;

  /// The name of the location.
  final String? name;

  /// The full address of the location.
  final String? address;

  const UpsertPlaceWidgetState._({
    required this.lat,
    required this.lng,
    required this.name,
    required this.address,
    required super.status,
    super.error,
  });

  /// Creates a new instance of [UpsertPlaceWidgetState].
  const UpsertPlaceWidgetState.initial()
      : lat = null,
        lng = null,
        name = null,
        address = null,
        super.initial();

  @override
  UpsertPlaceWidgetState copyWith({
    required StateStatus status,
    String? name,
    Option<String?> address = const Option.none(),
    double? lat,
    double? lng,
  }) =>
      UpsertPlaceWidgetState._(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        name: name ?? this.name,
        address: address.getOrElse(() => this.address),
        error: error,
        status: status,
      );

  @override
  UpsertPlaceWidgetState copyWithError(WError error) =>
      UpsertPlaceWidgetState._(
        lat: lat,
        lng: lng,
        name: name,
        address: address,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        lat,
        lng,
        name,
        address,
        ...super.props,
      ];
}
