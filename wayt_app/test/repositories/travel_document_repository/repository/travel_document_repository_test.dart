import 'package:flext/flext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wayt_app/init/in_memory_data.dart';
import 'package:wayt_app/repositories/repositories.dart';

class MockTravelDocumentDataSource extends Mock
    implements TravelDocumentDataSource {}

class MockPlan extends Mock implements PlanEntity {}

void main() {
  late MockTravelDocumentDataSource mockTravelDocumentDataSource;
  late TravelDocumentRepository repo;
  late InMemoryDataHelper inMemoryData;

  setUp(() {
    inMemoryData = InMemoryDataHelper();
    mockTravelDocumentDataSource = MockTravelDocumentDataSource();
    repo = TravelDocumentRepository(
      dataSource: mockTravelDocumentDataSource,
      summaryHelperRepository: SummaryHelperRepository(),
    );

    registerFallbackValue(MockPlan());
  });

  group('create', () {
    test('should create the entity and emit a new state', () async {
      final input = CreatePlanInput(
        userId: 'userId',
        isDaySet: true,
        isMonthSet: false,
        plannedAt: DateTime.now(),
        tags: ['tag'],
        name: 'name',
      );
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<TravelDocumentRepositoryEntityAdded>());
        emitted = true;
      });
      when(() => mockTravelDocumentDataSource.createPlan(input))
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
          updatedAt: null,
        );
      });
      final created = await repo.createPlan(input);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockTravelDocumentDataSource.createPlan(input));
      expect(emitted, isTrue);
      expect(repo.items, hasLength(1));
      expect(repo.items.single.id, created.id);
    });
  });

  group('update', () {
    test('should update the entity and emit a new state', () async {
      final input = CreatePlanInput(
        userId: 'userId',
        isDaySet: true,
        isMonthSet: false,
        plannedAt: DateTime.now(),
        tags: ['tag'],
        name: 'name',
      );
      when(() => mockTravelDocumentDataSource.createPlan(input))
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
          updatedAt: null,
        );
      });
      final created = await repo.createPlan(input);
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<TravelDocumentRepositoryItemUpdated>());
        emitted = true;
      });

      final UpdatePlanInput updateInput = (
        isDaySet: true,
        isMonthSet: true,
        plannedAt: DateTime.now(),
        tags: ['tag', 'tag2'],
        name: 'name updated',
      );
      when(
        () => mockTravelDocumentDataSource.updatePlan(
          created.id,
          input: updateInput,
        ),
      ).thenAnswer((invocation) async {
        final input =
            invocation.namedArguments[const Symbol('input')] as UpdatePlanInput;
        return PlanModel(
          id: created.id,
          userId: created.userId,
          isDaySet: input.isDaySet,
          isMonthSet: input.isMonthSet,
          plannedAt: input.plannedAt,
          tags: input.tags,
          name: input.name,
          createdAt: created.createdAt,
          updatedAt: DateTime.now(),
        );
      });
      final updated = await repo.updatePlan(created.id, updateInput);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(
        () => mockTravelDocumentDataSource.updatePlan(
          created.id,
          input: updateInput,
        ),
      );
      expect(emitted, isTrue);
      expect(repo.items, hasLength(1));
      expect(repo.items.single.id, created.id);
      expect(repo.items.single.id, updated.id);
      expect(repo.items.single.name, updateInput.name);
    });
  });

  group('fetchOne', () {
    test('should fetch the entity and emit a new state', () async {
      when(() => mockTravelDocumentDataSource.readById(any())).thenAnswer(
        (invocation) async => inMemoryData
            .getPlan(invocation.positionalArguments[0] as String)
            .let(
              (response) => TravelDocumentWrapper(
                travelDocument: response,
                travelItems: [],
              ),
            ),
      );
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<TravelDocumentRepositoryItemFetched>());
        emitted = true;
      });
      final plan = inMemoryData.sortedPlans.first;
      final fetched = await repo.fetchOne(plan.id);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockTravelDocumentDataSource.readById(plan.id));
      expect(emitted, isTrue);
      expect(repo.items, hasLength(1));
      expect(repo.items.single.id, fetched.travelDocument.id);
    });
  });

  group('delete', () {
    test('should delete the entity and emit a new state', () async {
      when(() => mockTravelDocumentDataSource.delete(any())).thenAnswer(
        (invocation) async => inMemoryData
            .deletePlan(invocation.positionalArguments[0] as String),
      );
      final plan = inMemoryData.sortedPlans.first;
      repo.add(plan, shouldEmit: false);
      var emitted = false;
      repo.listen((state) {
        expect(state, isA<TravelDocumentRepositoryItemDeleted>());
        emitted = true;
      });
      await repo.delete(plan.id);

      // Wait for the state to be emitted.
      await Future<void>.delayed(const Duration(seconds: 1));

      verify(() => mockTravelDocumentDataSource.delete(plan.id));
      expect(emitted, isTrue);
      expect(repo.items, isEmpty);
      expect(inMemoryData.containsTravelDocument(plan.tid), isFalse);
    });
  });
}
