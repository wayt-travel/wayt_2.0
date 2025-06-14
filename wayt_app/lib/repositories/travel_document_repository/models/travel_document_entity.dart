import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

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
