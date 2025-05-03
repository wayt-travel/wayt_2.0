part of 'upsert_transfer_widget_cubit.dart';

/// The state of the [UpsertTransferWidgetCubit].
final class UpsertTransferWidgetState extends SuperBlocState<WError> {
  /// The stops of the transfer.
  final List<TransferStop> stops;

  /// The means of transport of the transfer.
  final MeansOfTransportType? meansOfTransport;

  const UpsertTransferWidgetState._({
    required this.stops,
    required this.meansOfTransport,
    required super.status,
    super.error,
  });

  /// Creates an initial state.
  const UpsertTransferWidgetState.initial()
      : stops = const [],
        meansOfTransport = null,
        super.initial();

  @override
  UpsertTransferWidgetState copyWith({
    required StateStatus status,
    Option<MeansOfTransportType?> meansOfTransport = const None(),
    List<TransferStop>? stops,
  }) =>
      UpsertTransferWidgetState._(
        stops: stops ?? this.stops,
        meansOfTransport: meansOfTransport.getOr(this.meansOfTransport),
        error: error,
        status: status,
      );

  @override
  UpsertTransferWidgetState copyWithError(WError error) =>
      UpsertTransferWidgetState._(
        stops: stops,
        meansOfTransport: meansOfTransport,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        stops,
        meansOfTransport,
        ...super.props,
      ];
}
