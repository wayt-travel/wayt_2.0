import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luthor/luthor.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/core.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';
import '../../../../util/util.dart';

part 'upsert_transfer_widget_state.dart';

/// {@template upsert_transfer_widget_cubit}
/// Cubit for adding or editing a transfer widget.
/// {@endtemplate}
class UpsertTransferWidgetCubit extends Cubit<UpsertTransferWidgetState>
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
  final TransferWidgetModel? widgetToUpdate;

  /// Whether the cubit is in update mode.
  bool get isUpdate => widgetToUpdate != null;

  /// {@macro upsert_transfer_widget_cubit}
  UpsertTransferWidgetCubit({
    required this.index,
    required this.travelDocumentId,
    required this.travelItemRepository,
    required this.widgetToUpdate,
    required this.folderId,
  }) : super(const UpsertTransferWidgetState.initial());

  /// Adds a stop to the list of stops of the transfer.
  void addStop(TransferStop stops) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        stops: state.stops + [stops],
      ),
    );
  }

  /// Removes a stop from the list of stops of the transfer.
  void removeStop(TransferStop stop) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        stops: state.stops.toList()..remove(stop),
      ),
    );
  }

  /// Updates a stop in the list of stops of the transfer.
  void setStops(List<TransferStop> stops) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        stops: stops,
      ),
    );
  }

  /// Updates the means of transport.
  void updateMeansOfTransport(MeansOfTransportType meansOfTransport) {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        meansOfTransport: Option.of(meansOfTransport),
      ),
    );
  }

  /// Returns the validator for the stops field.
  ///
  /// The only field that really requires validation is the date and time of the
  /// stop because we want stops to be in chronological order.
  Validator getStopValidator({BuildContext? context}) => l.custom(
        (stop) {
          if (stop == null || stop is! TransferStop) return false;
          final i = state.stops.indexOf(stop);
          // The first stop is always valid
          if (i == 0) return true;
          final dt = stop.dateTime;
          // If the date and time is null, the stop is valid
          if (dt == null) return true;
          final previousStops = state.stops.sublist(0, i);
          return previousStops.fold(
            true,
            // Check if the date and time of the stop is after all the
            // date and time of the previous stops
            (acc, s) => acc && (s.dateTime == null || s.dateTime!.isBefore(dt)),
          );
        },
        // FIXME: l10n
        message: 'The date and time of this stop must not be before any of '
            'the previous stops',
      );

  Validator getStopsValidator(BuildContext? context) => l.custom(
        (stops) {
          final timestamps = state.stops.map((stop) => stop.dateTime).toList();
          final timestampsNotNull = timestamps.nonNulls.toList();
          return listEquals(timestampsNotNull, timestampsNotNull.sorted());
        },
        message: 'Make sure stops are in chronological order',
      );

  /// Returns the validator for the means of transport field.
  static Validator getMeansOfTransportValidator(BuildContext? context) =>
      Validators.l10n(context).required();

  SchemaValidationResult<Map<String, dynamic>> validate(
    BuildContext? context,
  ) {
    return l.schema({
      'stops': getStopsValidator(context),
      'meansOfTransport': getMeansOfTransportValidator(context),
    }).validateSchema<Map<String, dynamic>>({
      'stops': state.stops,
      'meansOfTransport': state.meansOfTransport,
    });
  }

  /// Submits the creation/update of the widget based on the current state.
  ///
  /// Before calling this method, make sure to call [validate] to ensure
  /// the state is valid.
  Future<void> submit() async {
    logger.d(
      !isUpdate
          ? 'Submitting new transfer widget'
          : 'Updating transfer widget $widgetToUpdate',
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
        stops: state.stops,
        meansOfTransport: state.meansOfTransport,
      );
      // TODO: Implement transfer widget update
      throw UnimplementedError(
        'Update widget not implemented yet. Widget: $widget',
      );
    } else {
      final widget = TransferWidgetModel(
        id: const Uuid().v4(),
        order: -1,
        travelDocumentId: travelDocumentId,
        stops: state.stops,
        meansOfTransport: state.meansOfTransport!,
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
          logger.e('Error upserting transfer: $error');
          emit(state.copyWithError(error));
        },
        (_) {
          logger.i('Transfer widget upserted successfully');
          emit(
            state.copyWith(status: StateStatus.success),
          );
        },
      );
    }
  }
}
