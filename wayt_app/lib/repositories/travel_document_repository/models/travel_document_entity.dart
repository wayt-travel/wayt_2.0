import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:luthor/luthor.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

/// {@template travel_document_json_converter}
/// A JSON converter for [TravelDocumentEntity] that can handle both plans and
/// journals.
/// {@endtemplate}
class TravelDocumentJsonConverter
    extends JsonConverter<TravelDocumentEntity, Json> {
  /// {@macro travel_document_json_converter}
  const TravelDocumentJsonConverter();

  @override
  TravelDocumentEntity fromJson(Map<String, dynamic> json) {
    try {
      return PlanModel.fromJson(json);
    } catch (e) {
      // Handle the case where the JSON does not match the expected format.
      // FIXME: return JournalModel.fromJson(json);
      throw UnimplementedError(
        'Failed to parse TravelDocumentEntity from JSON: $e',
      );
    }
  }

  @override
  Map<String, dynamic> toJson(TravelDocumentEntity object) => object.match(
        onPlan: (plan) => (plan as PlanModel).toJson(),
        // FIXME: This should be a JournalEntity.
        onJournal: (journal) => throw UnimplementedError(),
      );
}

/// Common entity interface for all travel documents, i.e., plans and journals.
abstract interface class TravelDocumentEntity
    implements Entity, ResourceEntity {
  /// The name of the travel plan.
  String get name;

  /// The id of the owner of the travel plan.
  String get userId;

  /// The travel document id.
  TravelDocumentId get tid;

  /// Casts this entity to a [PlanEntity].
  ///
  /// Throws an error if this entity is not a plan.
  PlanEntity get asPlan;

  /// Casts this entity to a `JournalEntity`.
  ///
  /// Throws an error if this entity is not a journal.
  /// FIXME: This should be a JournalEntity.
  dynamic get asJournal;

  /// Whether this entity is a plan.
  bool get isPlan;

  /// Whether this entity is a journal.
  bool get isJournal;

  /// Matches this entity to a specific type.
  T match<T>({
    required T Function(PlanEntity) onPlan,

    /// FIXME: This should be a JournalEntity.
    required T Function(dynamic) onJournal,
  });

  /// Returns a validator for the name of the travel document.
  static Validator getNameValidator(BuildContext? context) =>
      Validators.l10n(context).textShortRequired();
}
