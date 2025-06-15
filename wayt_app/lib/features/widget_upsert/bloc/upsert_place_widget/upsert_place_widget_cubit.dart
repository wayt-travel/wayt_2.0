import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/core.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';

part 'upsert_place_widget_state.dart';

/// {@template upsert_place_widget_cubit}
/// Cubit for adding or editing a place widget.
/// {@endtemplate}
class UpsertPlaceWidgetCubit extends Cubit<UpsertPlaceWidgetState>
    with LoggerMixin {
  /// The id of the travel document where the widget will be added.
  final TravelDocumentId travelDocumentId;

  /// The index where the widget will be added.
  ///
  /// Null if the widget is being edited (as the index is not needed) or if the
  /// widget is being added at the end of the list.
  final int? index;

  /// Id of the folder where the widget will be added.
  ///
  /// Null if the widget is being added at the root of the travel document.
  ///
  /// If the widget is being edited, this value is ignored.
  final String? folderId;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The widget entity to update.
  ///
  /// If `null` it means we're in create mode, i.e., a new widget will be
  /// created.
  final PlaceWidgetModel? widgetToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => widgetToUpdate != null;

  /// {@macro upsert_place_widget_cubit}
  UpsertPlaceWidgetCubit({
    required this.index,
    required this.travelDocumentId,
    required this.travelItemRepository,
    required this.widgetToUpdate,
    required this.folderId,
  }) : super(const UpsertPlaceWidgetState.initial());

  /// Updates the latitude of the place.
  void updateLat(double? lat) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        lat: lat,
      ),
    );
  }

  /// Updates the longitude of the place.
  void updateLng(double? lng) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        lng: lng,
      ),
    );
  }

  /// Updates the address of the place.
  void updateAddress(String? address) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        address: Option.of(address?.trim()),
      ),
    );
  }

  /// Updates the name of the place.
  void updateName(String? name) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        name: name?.trim(),
      ),
    );
  }

  /// Returns the validator for the latitude field.
  Validator getLatValidator(BuildContext? context) =>
      Validators.l10n(context).latitude();

  /// Returns the validator for the longitude field.
  Validator getLngValidator(BuildContext? context) =>
      Validators.l10n(context).longitude();

  /// Returns the validator for the name field.
  Validator getNameValidator(BuildContext? context) =>
      Validators.l10n(context).textShortRequired();

  /// Returns the validator for the address field.
  Validator getAddressValidator(BuildContext? context) =>
      Validators.l10n(context).textShortOptional();

  /// Validates the current state of the cubit.
  SchemaValidationResult<Json> validate(BuildContext? context) {
    return l.schema({
      'lat': getLatValidator(context),
      'lng': getLngValidator(context),
      'name': getNameValidator(context),
      'address': getAddressValidator(context),
    }).validateSchema<Json>({
      'lat': state.lat,
      'lng': state.lng,
      'name': state.name,
      'address': state.address,
    });
  }

  /// Submits the creation/update of the widget based on the current state.
  ///
  /// Before calling this method, make sure to call [validate] to ensure
  /// the state is valid.
  Future<void> submit() async {
    logger.d(
      !isUpdate ? 'Submitting new widget' : 'Updating widget $widgetToUpdate',
    );
    emit(
      state.copyWith(status: StateStatus.progress),
    );
    if (!validate(null).isValid) {
      logger.wtf(
        'Invalid cubit state $state. It should have been validated before '
        'submitting!!!',
      );
      emit(state.copyWithError($.errors.validation.invalidCubitState));
      return;
    }

    if (isUpdate) {
      final widget = widgetToUpdate!.copyWith(
        name: state.name,
        address: Option.of(state.address),
        latLng: LatLng(state.lat!, state.lng!),
      );
      // TODO: Implement place widget update
      throw UnimplementedError(
        'Update widget not implemented yet. Widget: $widget',
      );
    } else {
      final widget = PlaceWidgetModel(
        id: const Uuid().v4(),
        order: -1,
        travelDocumentId: travelDocumentId,
        latLng: LatLng(state.lat!, state.lng!),
        name: state.name!,
        address: state.address,
        folderId: folderId,
      );

      final result = await travelItemRepository
          .createWidget(
            widget: widget,
            index: index,
          )
          .run();

      result.match(
        (error) {
          logger.e('Error upserting place: $error');
          emit(state.copyWithError(error));
        },
        (_) {
          logger.i('Place widget upserted successfully');
          emit(
            state.copyWith(status: StateStatus.success),
          );
        },
      );
    }
  }
}
