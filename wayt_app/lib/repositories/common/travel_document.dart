import '../repositories.dart';

/// Common interface for all travel documents, i.e., plans and journals.
abstract interface class TravelDocument {
  /// The name of the travel plan.
  String get name;

  /// The id of the owner of the travel plan.
  String get userId;

  /// The travel document id.
  TravelDocumentId get tid;
}
