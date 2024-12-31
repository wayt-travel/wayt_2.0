import '../../repositories.dart';

abstract interface class PlanDataSource {
  /// Create a new plan.
  Future<PlanModel> create(CreatePlanInput input);

  /// Read all plans of a user.
  ///
  /// The plans are returned in order of their planned date ASC.
  Future<List<PlanSummaryModel>> readAllOfUser(String userId);

  /// Read a plan by its id.
  ///
  /// It returns the plan with its items.
  Future<FetchPlanResponse> readById(String id);

  /// Delete a plan by its id.
  Future<void> delete(String id);
}
