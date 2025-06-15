import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../core/core.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';

part 'upsert_transfer_stop_state.dart';

/// {@template upsert_transfer_stop_cubit}
/// Cubit for adding or editing a transfer stop.
/// {@endtemplate}
class UpsertTransferStopCubit extends Cubit<UpsertTransferStopState>
    with LoggerMixin {
  /// The id of the travel document where the stop belongs.
  ///
  /// The stop is not a widget directly added to the travel document, but it is
  /// part of a transfer widget.
  final TravelDocumentId travelDocumentId;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document repository.
  final TravelDocumentRepository travelDocumentRepository;

  /// The transfer stop to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new transfer stop will be
  /// created. Otherwise, the cubit is in update mode.
  final TransferStop? stopToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => stopToUpdate != null;

  /// The initial date time to suggest to the user when launching the picker
  /// for the date time.
  final DateTime suggestedInitialDateTime;

  /// {@macro upsert_transfer_stop_cubit}
  UpsertTransferStopCubit({
    required this.travelDocumentId,
    required this.travelItemRepository,
    required this.travelDocumentRepository,
    required this.stopToUpdate,
    required this.suggestedInitialDateTime,
  }) : super(UpsertTransferStopState.initial(stopToUpdate));

  /// Updates the name of the stop.
  void updateName(String name) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        name: name.trim(),
      ),
    );
  }

  /// Updates the address of the stop.
  void updateAddress(String? address) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        address: Option.of(address?.trim()),
      ),
    );
  }

  /// Updates the latitude and longitude of the stop.
  void updateLatLng(LatLng latLng) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        lat: Option.of(latLng.latitude),
        lng: Option.of(latLng.longitude),
      ),
    );
  }

  /// Updates the latitude of the stop.
  void updateLat(double? lat) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        lat: Option.of(lat),
      ),
    );
  }

  /// Updates the longitude of the stop.
  void updateLng(double? lng) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        lng: Option.of(lng),
      ),
    );
  }

  /// Updates the timestamp of the stop.
  void updateDateTime(DateTime? dateTime) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        dateTime: Option.of(dateTime),
      ),
    );
  }

  /// Updates the state from a [GeoWidgetFeatureEntity].
  void updateFromGeoFeature(GeoWidgetFeatureEntity geoFeature) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        name: geoFeature.name,
        address: Option.of(geoFeature.address),
        lat: Option.of(geoFeature.latLng.latitude),
        lng: Option.of(geoFeature.latLng.longitude),
      ),
    );
  }

  /// Returns the validator for the name field.
  Validator getNameValidator(BuildContext? context) =>
      Validators.l10n(context).textShortRequired();

  /// Returns the validator for the address field.
  Validator getAddressValidator(BuildContext? context) =>
      Validators.l10n(context).textShortOptional();

  /// Returns the validator for the latitude field.
  Validator getLatValidator(BuildContext? context) =>
      Validators.l10n(context).latitude();

  /// Returns the validator for the longitude field.
  Validator getLngValidator(BuildContext? context) =>
      Validators.l10n(context).longitude();

  /// Validates the current state of the cubit.
  SchemaValidationResult<Map<String, dynamic>> validate(BuildContext? context) {
    return l.schema({
      'name': getNameValidator(context),
      'address': getAddressValidator(context),
      'lat': getLatValidator(context),
      'lng': getLngValidator(context),
    }).validateSchema<Map<String, dynamic>>({
      'name': state.name,
      'address': state.address,
      'lat': state.lat,
      'lng': state.lng,
    });
  }

  /// Submits the transfer stop based on the current state.
  ///
  /// Before calling this method, make sure to call [validate] to ensure
  /// the state is valid.
  Future<TransferStop?> submit() async {
    logger.d(
      isUpdate
          ? 'Updating transfer stop $stopToUpdate'
          : 'Creating new transfer stop',
    );
    emit(state.copyWith(status: StateStatus.progress));

    if (!validate(null).isValid) {
      logger.wtf(
        'Invalid cubit state $state. It should have been validated before '
        'submitting!!!',
      );
      emit(state.copyWithError($.errors.validation.invalidCubitState));
      return null;
    }

    final stop = TransferStop(
      name: state.name,
      address: state.address,
      latLng: LatLng(state.lat!, state.lng!),
      dateTime: state.dateTime,
    );

    emit(state.copyWith(status: StateStatus.success));
    return stop;
  }
}
