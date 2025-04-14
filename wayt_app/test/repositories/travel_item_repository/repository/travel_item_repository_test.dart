import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/repositories/repositories.dart';

class MockWidgetFolderDataSource extends Mock
    implements WidgetFolderDataSource {}

class MockWidgetDataSource extends Mock implements WidgetDataSource {}

class MockTravelItemDataSource extends Mock implements TravelItemDataSource {}

class MockSummaryHelperRepository extends Mock
    implements SummaryHelperRepository {}

TextWidgetModel _buildWidget({
  required TravelDocumentId travelDocumentId,
  required int order,
  String? folderId,
}) =>
    TextWidgetModel(
      id: const Uuid().v4(),
      text: 'text',
      textStyle: const TypographyFeatureStyle.body(),
      travelDocumentId: travelDocumentId,
      folderId: folderId,
      order: order,
    );

WidgetFolderModel _buildFolder({
  required TravelDocumentId travelDocumentId,
  required int order,
  String? name,
  String? id,
}) =>
    WidgetFolderModel(
      id: id ?? const Uuid().v4(),
      travelDocumentId: travelDocumentId,
      order: order,
      color: FeatureColor.amber,
      createdAt: DateTime.now(),
      icon: WidgetFolderIcon.fromIconData(Icons.folder),
      name: name ?? 'name',
      updatedAt: null,
    );

void main() {
  late TravelItemRepositoryImpl repository;
  final travelDocumentId = TravelDocumentId.plan(const Uuid().v4());
  final travelDocumentId2 = TravelDocumentId.plan(const Uuid().v4());

  setUp(() async {
    repository = TravelItemRepositoryImpl(
      travelItemDataSource: MockTravelItemDataSource(),
      widgetFolderDataSource: MockWidgetFolderDataSource(),
      widgetDataSource: MockWidgetDataSource(),
      summaryHelperRepository: MockSummaryHelperRepository(),
    );

    await repository.addConcurrentAndWait<void>(
      TravelItemRepoItemsAddedEvent(
        travelItems: [
          TravelItemEntityWrapper.widget(
            _buildWidget(travelDocumentId: travelDocumentId2, order: 0),
          ),
        ],
      ),
    );
  });

  group('TravelItemRepository.upsertInCacheAndMaps', () {
    test('should insert the item in the cache', () {
      expect(repository.items.length, equals(1));
      expect(repository.travelDocumentToItemsMap.entries.length, equals(1));
      final td = repository.travelDocumentToItemsMap.entries.single;
      expect(td.key, travelDocumentId2);
      final widget = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      repository.upsertInCacheAndMaps(widget);
      expect(repository.get(widget.id), equals(widget));
      expect(repository.travelDocumentToItemsMap.entries.length, equals(2));
      final td2 = repository.travelDocumentToItemsMap.entries.last;
      expect(td2.key, travelDocumentId);
      final items = td2.value;
      expect(items.length, equals(1));
    });

    test('should insert the item preserving the ordering', () {
      final widget1 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      final widget2 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 1,
      );
      final widget3 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 2,
      );
      repository.upsertInCacheAndMaps(widget3);
      expect(repository.get(widget3.id), equals(widget3));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.single,
        equals(widget3.id),
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.values.single.id,
        equals(widget3.id),
      );

      repository.upsertInCacheAndMaps(widget1);
      expect(repository.get(widget1.id), equals(widget1));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.first,
        equals(widget1.id),
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.values.first.id,
        equals(widget1.id),
      );

      repository.upsertInCacheAndMaps(widget2);
      expect(repository.get(widget2.id), equals(widget2));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.toList()[1],
        equals(widget2.id),
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.values
            .toList()[1]
            .id,
        equals(widget2.id),
      );

      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.length,
        equals(3),
      );
      expect(
        const ListEquality<String>().equals(
          repository.travelDocumentToItemsMap[travelDocumentId]!.keys.toList(),
          [widget1.id, widget2.id, widget3.id],
        ),
        isTrue,
      );
    });

    test('should replace an existing item', () {
      final widget1 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 1,
      );
      final widget2 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 2,
      );
      repository
        ..upsertInCacheAndMaps(widget1)
        ..upsertInCacheAndMaps(widget2);
      expect(repository.get(widget1.id), equals(widget1));
      expect(repository.get(widget2.id), equals(widget2));
      expect(
        const ListEquality<String>().equals(
          repository.travelDocumentToItemsMap[travelDocumentId]!.keys.toList(),
          [widget1.id, widget2.id],
        ),
        isTrue,
      );

      final updated2 = widget2.copyWith(order: 0);
      repository.upsertInCacheAndMaps(updated2);
      expect(repository.get(updated2.id), equals(updated2));
      expect(
        const ListEquality<String>().equals(
          repository.travelDocumentToItemsMap[travelDocumentId]!.keys.toList(),
          // Now widget2 should be the first
          [updated2.id, widget1.id],
        ),
        isTrue,
      );
    });

    test('should give no problem if adding two items with the same order', () {
      final widget1 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      final widget2 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      final widget3 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      repository
        ..upsertInCacheAndMaps(widget1)
        ..upsertInCacheAndMaps(widget2)
        ..upsertInCacheAndMaps(widget3);
      expect(
        const ListEquality<String>().equals(
          repository.travelDocumentToItemsMap[travelDocumentId]!.keys.toList(),
          // it should be sorted by id if the order is the same
          [widget1.id, widget2.id, widget3.id].sorted(),
        ),
        isTrue,
      );
    });

    test(
      'should throw if the widget has a folder that is not present the repo',
      () {
        final widget = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 0,
          folderId: const Uuid().v4(),
        );
        expect(
          () => repository.upsertInCacheAndMaps(widget),
          throwsA(isA<StateError>()),
        );
      },
    );

    test(
      'should throw if the widget has a folder that is not actually a folder',
      () {
        final notAFolder = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 0,
        );
        final widget = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 1,
          folderId: notAFolder.id,
        );
        expect(
          () => repository.upsertInCacheAndMaps(widget),
          throwsA(isA<StateError>()),
        );
      },
    );

    test('should insert the widget in its folder if it has a folder', () {
      final folder = _buildFolder(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      repository.upsertInCacheAndMaps(folder);
      expect(repository.get(folder.id), equals(folder));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.single,
        equals(folder.id),
      );

      final widget = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 1,
        folderId: folder.id,
      );
      repository.upsertInCacheAndMaps(widget);
      // The widget is in the cache
      expect(repository.get(widget.id), equals(widget));

      // The widget should not be in the root of the travel document
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.contains(
          widget.id,
        ),
        isFalse,
      );

      // The widget should be in the folder.
      final folderHelper =
          repository.travelDocumentToItemsMap[travelDocumentId]![folder.id]!;
      expect(folderHelper.isFolder, isTrue);
      expect(folderHelper.widgetIds?.contains(widget.id), isTrue);
    });
  });

  group('TravelItemRepository.updateItemOrders', () {
    test('should throw if the travel document is not present', () {
      expect(
        () => repository.updateItemOrders(
          TravelDocumentId.journal(const Uuid().v4()),
          {
            travelDocumentId2.id: 100,
          },
        ),
        throwsA(isA<StateError>()),
      );
    });
    test(
      'should throw if any of the items id in the map is not present in the '
      'repository ',
      () {
        expect(
          () => repository.updateItemOrders(
            travelDocumentId2,
            {
              const Uuid().v4(): 100,
            },
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
    test(
      'should throw if the updatedOrders map contains the id of an item '
      'belonging to a travel document that is not the one in input',
      () {
        expect(
          () => repository.updateItemOrders(
            travelDocumentId2,
            {
              travelDocumentId.id: 100,
            },
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
    test(
      'should update the order of an item in the root of the travel document',
      () {
        final widget1 = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 0,
        );
        final widget2 = _buildFolder(
          travelDocumentId: travelDocumentId,
          order: 1,
        );
        final widgetInsideFolder = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 0,
          folderId: widget2.id,
        );
        final widget3 = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 2,
        );
        repository
          ..upsertInCacheAndMaps(widget1)
          ..upsertInCacheAndMaps(widget2)
          ..upsertInCacheAndMaps(widgetInsideFolder)
          ..upsertInCacheAndMaps(widget3);
        expect(
          const ListEquality<String>().equals(
            repository.travelDocumentToItemsMap[travelDocumentId]!.keys
                .toList(),
            [widget1.id, widget2.id, widget3.id],
          ),
          isTrue,
        );
        repository.updateItemOrders(
          travelDocumentId,
          {
            widget3.id: 100,
            widget2.id: 200,
            widget1.id: 300,
          },
        );
        expect(repository.getOrThrow(widget3.id).order, equals(100));
        expect(repository.getOrThrow(widget2.id).order, equals(200));
        expect(repository.getOrThrow(widget1.id).order, equals(300));
        expect(
          const ListEquality<String>().equals(
            repository.travelDocumentToItemsMap[travelDocumentId]!.keys
                .toList(),
            [widget3.id, widget2.id, widget1.id],
          ),
          isTrue,
        );
        repository
            .getWrappedOrThrow(widget2.id)
            .asFolderWidgetWrapper
            .children
            .let((children) {
          expect(children, hasLength(1));
          expect(children[0].id, equals(widgetInsideFolder.id));
        });
      },
    );

    test('should update the order of a widget in a folder', () {
      final folder = _buildFolder(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      final widget1 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 1,
        folderId: folder.id,
      );
      final widget2 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 2,
        folderId: folder.id,
      );
      final widget3 = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 3,
        folderId: folder.id,
      );
      repository
        ..upsertInCacheAndMaps(folder)
        ..upsertInCacheAndMaps(widget1)
        ..upsertInCacheAndMaps(widget2)
        ..upsertInCacheAndMaps(widget3);
      expect(
        repository
            .travelDocumentToItemsMap[travelDocumentId]![folder.id]!.widgetIds,
        equals([widget1.id, widget2.id, widget3.id]),
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!
            .containsKey(widget1.id),
        isFalse,
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!
            .containsKey(widget2.id),
        isFalse,
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!
            .containsKey(widget3.id),
        isFalse,
      );
      repository.updateItemOrders(
        travelDocumentId,
        {
          widget3.id: 100,
          widget2.id: 200,
          widget1.id: 300,
        },
      );
      expect(repository.getOrThrow(widget3.id).order, equals(100));
      expect(repository.getOrThrow(widget2.id).order, equals(200));
      expect(repository.getOrThrow(widget1.id).order, equals(300));
      expect(
        repository
            .travelDocumentToItemsMap[travelDocumentId]![folder.id]!.widgetIds,
        equals([widget3.id, widget2.id, widget1.id]),
      );
    });
  });

  group('TravelItemRepository.removeFromCacheAndMaps', () {
    test('should delete the item from the cache and map', () {
      final widget = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      repository.upsertInCacheAndMaps(widget);
      expect(repository.get(widget.id), equals(widget));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys.single,
        equals(widget.id),
      );
      repository.removeFromCacheAndMaps(widget);
      expect(repository.get(widget.id), isNull);
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]!.keys
            .contains(widget.id),
        isFalse,
      );
    });
    test('should do nothing if the item travel document does not exist', () {
      final widget = _buildWidget(
        travelDocumentId: travelDocumentId,
        order: 0,
      );
      repository.removeFromCacheAndMaps(widget);
      expect(repository.get(widget.id), isNull);
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId]?.keys
                .contains(widget.id) ??
            false,
        isFalse,
      );
    });

    test(
      'should delete the item from the folder widget id list if it is a widget '
      'contained in a folder',
      () {
        final folder = _buildFolder(
          travelDocumentId: travelDocumentId,
          order: 0,
        );
        final widget = _buildWidget(
          travelDocumentId: travelDocumentId,
          order: 0,
          folderId: folder.id,
        );
        repository
          ..upsertInCacheAndMaps(folder)
          ..upsertInCacheAndMaps(widget);
        expect(
          repository.travelDocumentToItemsMap[travelDocumentId]![folder.id]!
              .widgetIds,
          equals([widget.id]),
        );
        repository.removeFromCacheAndMaps(widget);
        expect(
          repository.travelDocumentToItemsMap[travelDocumentId]![folder.id]!
              .widgetIds,
          isEmpty,
        );
      },
    );
  });

  group('Create', () {
    test('Create a folder', () async {
      final input = (
        color: FeatureColor.blue,
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
        name: 'Name',
        travelDocumentId: travelDocumentId2,
        index: 0,
      );

      when(() => repository.widgetFolderDataSource.create(input))
          .thenAnswer((invocation) async {
        final input =
            invocation.positionalArguments[0] as CreateWidgetFolderInput;
        final folder = WidgetFolderModel(
          id: '1',
          travelDocumentId: input.travelDocumentId,
          createdAt: DateTime.now().toUtc(),
          updatedAt: null,
          order: -1,
          name: input.name,
          icon: input.icon,
          color: input.color,
        );
        return (
          widgetFolder: folder,
          updatedOrders: <String, int>{},
        );
      });

      final created = await repository.createFolder(input);
      verify(() => repository.widgetFolderDataSource.create(input));
      expect(repository.travelDocumentToItemsMap, hasLength(1));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId2]?.keys.first,
        created.widgetFolder.id,
      );
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId2]?.keys.first,
        created.widgetFolder.id,
      );
      expect(
        repository
            .travelDocumentToItemsMap[travelDocumentId2]?.values.first.isFolder,
        isTrue,
      );
    });
  });
  group('Update', () {
    test('Update folder information', () async {
      final created = _buildFolder(
        travelDocumentId: travelDocumentId2,
        order: 0,
        id: '1',
      );
      repository.upsertInCacheAndMaps(created);

      final updateInput = (
        color: FeatureColor.red,
        name: 'New Name',
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
      );

      when(
        () => repository.widgetFolderDataSource.update(
          any(),
          travelDocumentId: travelDocumentId2,
          input: updateInput,
        ),
      ).thenAnswer((invocation) async {
        final input = invocation.namedArguments[const Symbol('input')]
            as UpdateWidgetFolderInput;
        final travelDocumentId =
            invocation.namedArguments[const Symbol('travelDocumentId')]
                as TravelDocumentId;
        final folder = WidgetFolderModel(
          id: '1',
          travelDocumentId: travelDocumentId,
          createdAt: created.createdAt,
          updatedAt: DateTime.now().toUtc(),
          order: -1,
          name: input.name,
          icon: input.icon,
          color: input.color,
        );
        return (
          widgetFolder: folder,
          updatedOrders: <String, int>{},
        );
      });

      final updated = await repository.updateFolder(
        created.id,
        travelDocumentId: travelDocumentId2,
        input: updateInput,
      );
      verify(
        () => repository.widgetFolderDataSource.update(
          created.id,
          travelDocumentId: travelDocumentId2,
          input: updateInput,
        ),
      );
      expect(repository.travelDocumentToItemsMap, hasLength(1));
      expect(
        repository.travelDocumentToItemsMap[travelDocumentId2]?.keys.first,
        updated.widgetFolder.id,
      );
      final td2 = repository.travelDocumentToItemsMap[travelDocumentId2];
      expect(td2, hasLength(2));
      final items = repository.getAllOfPlan(travelDocumentId2.id);
      final item = items.firstWhere((e) => e.value.id == '1');
      expect(item.isFolderWidget, isTrue);
      expect(item.value.asFolderWidget.name, updated.widgetFolder.name);
      expect(item.value.asFolderWidget.color, updated.widgetFolder.color);
    });
  });
}
