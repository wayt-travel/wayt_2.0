import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wayt_app/init/in_memory_data.dart';
import 'package:wayt_app/repositories/plan_repository/plan_repository.dart';

class MockPlanDataSource extends Mock implements PlanDataSource {}

class MockPlan extends Mock implements PlanEntity {}

void main() {
  late MockPlanDataSource mockPlanDataSource;
  late PlanRepository repo;
  final inMemoryData = InMemoryData();

  setUp(() {
    mockPlanDataSource = MockPlanDataSource();
    repo = PlanRepository(mockPlanDataSource);

    registerFallbackValue(MockPlan());
  });

  group('create', () {
    test('should create the entity and emit a new state', () async {
      final CreatePlanInput input = (
        userId: 'userId',
        isDaySet: true,
        isMonthSet: false,
        plannedAt: DateTime.now(),
        tags: ['tag'],
        name: 'name',
      );
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<PlanRepositoryPlanAdded>());
        emitted = true;
      });
      when(() => mockPlanDataSource.create(input))
          .thenAnswer((invocation) async {
        final input = invocation.positionalArguments[0] as CreatePlanInput;
        return PlanModel(
          id: 'id',
          userId: input.userId,
          isDaySet: input.isDaySet,
          isMonthSet: input.isMonthSet,
          plannedAt: input.plannedAt,
          tags: input.tags,
          name: input.name,
          createdAt: DateTime.now(),
          itemIds: [],
        );
      });
      final created = await repo.create(input);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockPlanDataSource.create(input));
      expect(emitted, isTrue);
      expect(repo.items, hasLength(1));
      expect(repo.items.single.id, created.id);
    });
  });

  group('fetchOne', () {
    test('should fetch the entity and emit a new state', () async {
      when(() => mockPlanDataSource.readById(any())).thenAnswer(
        (invocation) async => inMemoryData.plans
            .getOrThrow(invocation.positionalArguments[0] as String),
      );
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<PlanRepositoryPlanFetched>());
        emitted = true;
      });
      final plan = inMemoryData.plans.values.first;
      final fetched = await repo.fetchOne(plan.id);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockPlanDataSource.readById(plan.id));
      expect(emitted, isTrue);
      expect(repo.items, hasLength(1));
      expect(repo.items.single.id, fetched.id);
    });
  });

  group('delete', () {
    test('should delete the entity and emit a new state', () async {
      when(() => mockPlanDataSource.delete(any())).thenAnswer(
        (invocation) async => inMemoryData.plans
            .delete(invocation.positionalArguments[0] as String),
      );
      final plan = inMemoryData.plans.values.first;
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<PlanRepositoryPlanDeleted>());
        emitted = true;
      });
      await repo.delete(plan.id);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockPlanDataSource.delete(plan.id));
      expect(emitted, isTrue);
      expect(repo.items, isEmpty);
      expect(inMemoryData.plans.get(plan.id), isNull);
    });
  });
}
