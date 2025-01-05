import '../../repositories.dart';

abstract interface class PlanDataSource {
  /// Create a new plan.
  Future<PlanModel> create(CreatePlanInput input);

  /// Read all plans of a user.
  ///
  /// The plans are returned in order of their planned date ASC.
  Future<List<PlanModel>> readAllOfUser(String userId);

  /// Read a plan by its id.
  ///
  /// It returns the plan with its items.
  Future<PlanWithItems> readById(String id);

  /// Delete a plan by its id.
  Future<void> delete(String id);
}
