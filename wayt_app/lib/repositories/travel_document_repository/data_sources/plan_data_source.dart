import '../../repositories.dart';

/// Data source for travel documents.
abstract interface class TravelDocumentDataSource {
  /// Create a new plan.
  Future<PlanModel> createPlan(CreatePlanInput input);

  /// Read all plans of a user.
  ///
  /// The plans are returned in order of their planned date ASC.
  Future<List<PlanModel>> readAllPlansOfUser(String userId);

  /// Read a travel document by its id.
  ///
  /// It returns the travel document with its items.
  Future<TravelDocumentWrapper<TravelDocumentModel>> readById(String id);

  /// Delete a travel document by its id.
  Future<void> delete(String id);
}
