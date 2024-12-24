// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../plan_repository/plan_repository.dart';

class MockPlanDataSource extends Mock implements PlanDataSource {}

class MockPlan extends Mock implements PlanEntity {}

void main() {
  late MockPlanDataSource mockPlanDataSource;
  late PlanRepository repo;

  setUp(() {
    mockPlanDataSource = MockPlanDataSource();
    repo = PlanRepository(mockPlanDataSource);

    registerFallbackValue(MockPlan());
  });
}
