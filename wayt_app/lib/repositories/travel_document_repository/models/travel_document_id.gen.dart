import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_document_id.gen.g.dart';

/// Wrapper class for either a plan or a journal id.
@JsonSerializable(constructor: '_')
final class TravelDocumentId extends Equatable {
  /// The ID of the journal.
  ///
  /// If `null`, the ID is that of a plan.
  final String? journalId;

  /// The ID of the plan.
  ///
  /// If `null`, the ID is that of a journal.
  final String? planId;

  /// Constructor for JSON serialization.
  const TravelDocumentId._({this.journalId, this.planId})
      : assert(
          (journalId != null && planId == null) ||
              (journalId == null && planId != null),
          'Either journalId or planId must be non-null, but not both.',
        );

  /// Creates a travel document ID for a journal.
  const TravelDocumentId.journal(String this.journalId) : planId = null;

  /// Creates a travel document ID for a plan.
  const TravelDocumentId.plan(String this.planId) : journalId = null;

  /// Creates a travel document ID from a JSON.
  factory TravelDocumentId.fromJson(Json json) =>
      _$TravelDocumentIdFromJson(json);

  /// Converts this instance to a JSON map.
  Json toJson() => _$TravelDocumentIdToJson(this);

  /// Whether the ID is that of a journal.
  bool get isJournal => journalId != null;

  /// Whether the ID is that of a plan.
  bool get isPlan => planId != null;

  /// The raw string ID of the travel document.
  String get id => journalId ?? planId!;

  @override
  List<Object?> get props => [journalId, planId];

  @override
  String toString() =>
      '$TravelDocumentId($id, ${isJournal ? 'JOURNAL' : 'PLAN'})';
}
