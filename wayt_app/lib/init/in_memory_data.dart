import 'dart:math';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';
import 'package:world_countries/world_countries.dart';

import '../core/context/context.dart';
import '../repositories/repositories.dart';

Future<void> waitFakeTime() async {
  // Do not wait in local test.
  if ($.env.isLocalTest) return;
  await Future<void>.delayed(const Duration(milliseconds: 300));
}

const String loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
    'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat. Duis aute irure dolor in reprehenderit in voluptate '
    'velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
    'occaecat cupidatat non proident, sunt in culpa qui officia deserunt '
    'mollit anim id est laborum.';

final _rnd = Random(281994);
final _uuid = Uuid(
  goptions: GlobalOptions(
    MathRNG(seed: _rnd.nextInt(1000000)),
  ),
);

class _Data {
  final String authUserId = _uuid.v4();
  final Cache<String, UserModel> users;
  final Cache<TravelDocumentId, TravelDocumentEntity> travelDocuments;
  final Cache<String, TravelItemModel> travelItems;

  _Data({
    required this.users,
    required this.travelDocuments,
    required this.travelItems,
  });
}

class InMemoryDataHelper with LoggerMixin {
  final _data = _Data(
    users: Cache(),
    travelDocuments: Cache(),
    travelItems: Cache(),
  );

  InMemoryDataHelper() {
    _data.users.save(
      authUserId,
      UserModel(
        id: authUserId,
        email: 'john.doe@example.com',
        firstName: 'John',
        lastName: 'Doe',
      ),
    );
    _addPlans();
  }

  WidgetModel _buildTextWidget({
    required int order,
    required String text,
    required TravelDocumentId tid,
    FeatureTextStyle textStyle = const FeatureTextStyle.body(),
    String? folderId,
  }) =>
      TextWidgetModel(
        id: _uuid.v4(),
        order: order++,
        createdAt: DateTime.now().toUtc(),
        travelDocumentId: tid,
        text: text,
        textStyle: textStyle,
        folderId: folderId,
      );

  WidgetFolderModel _buildWidgetFolder({
    required String name,
    required int order,
    required TravelDocumentId tid,
  }) =>
      WidgetFolderModel(
        id: _uuid.v4(),
        order: order++,
        createdAt: DateTime.now().toUtc(),
        travelDocumentId: tid,
        name: name,
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
        color: FeatureColor.values.pickOneRandom(_rnd),
        updatedAt: null,
      );

  void _addWidgets(TravelDocumentId tid) {
    final titles = [
      'This is a heading!',
      'Stop #1',
      'Stop #2',
      'Stop #3',
      'Stop #4',
    ];
    var order = 0;
    for (final title in titles) {
      final items = <TravelItemModel>[
        _buildTextWidget(
          order: order++,
          text: title,
          textStyle: const FeatureTextStyle.h1(),
          tid: tid,
        ),
        ..._buildWidgetFolder(
          name: 'This is a folder',
          order: order++,
          tid: tid,
        ).let(
          (folder) => <TravelItemModel>[
            folder,
            _buildTextWidget(
              order: 0,
              text: 'This is a text inside the folder #1',
              tid: tid,
              folderId: folder.id,
            ),
            _buildTextWidget(
              order: 1,
              text: 'This is a text inside the folder #2',
              tid: tid,
              folderId: folder.id,
            ),
          ],
        ),
        _buildTextWidget(
          order: order++,
          text: 'We plan to visit this place. Here, then there, etc.'
              '\n\n$loremIpsum',
          tid: tid,
        ),
      ];
      _data.travelItems.saveAll({
        for (final item in items) item.id: item,
      });
    }
  }

  void _addPlans() {
    final countries = [...WorldCountry.list]..shuffle(_rnd);
    const planCount = 20;
    for (final i in List.generate(planCount, (i) => i)) {
      final tid = TravelDocumentId.plan(_uuid.v4());
      final country = countries.removeLast();
      final today = DateTime.now().toUtc().toDate();
      // Every 1.5 months approximately
      final dayOffset = ((i * 1.25 + 1) * 45).toInt();
      final plannedAt = DateTime.utc(
        today.year,
        today.month,
        today.day + dayOffset,
      );
      // If the planned date is later than 2.5 years from now, don't set it
      final isYearSet = plannedAt.difference(today).inDays < 365 * 2.5;
      // Set the month only if the planned date is less than 1.5 years from now
      final isMonthSet =
          isYearSet && plannedAt.difference(today).inDays < 365 * 1.5;
      // Set the day only if the planned date is less than 6 months from now
      final isDaySet =
          isMonthSet && plannedAt.difference(today).inDays < 365 / 2;
      _data.travelDocuments.save(
        tid,
        PlanModel(
          userId: _data.authUserId,
          createdAt: DateTime.now().toUtc(),
          id: tid.id,
          isMonthSet: isMonthSet,
          isDaySet: isDaySet,
          plannedAt: isYearSet ? plannedAt : null,
          tags: [country.name.name],
          name: 'Trip to ${country.name.name}',
          updatedAt: null,
        ),
      );
      _addWidgets(tid);
    }
  }

  /// Generates a new UUID.
  String generateUuid() => _uuid.v4();

  /// Gets the authenticated user ID.
  String get authUserId => _data.authUserId;

  /// Returns the authenticated user.
  UserModel get authUser => _data.users.getOrThrow(authUserId);

  /// Returns the user with the given [id].
  UserModel getUser(String id) => _data.users.getOrThrow(id);

  /// Tries to get the user with the given [email] from the users in the cache.
  UserModel? tryGetUserByEmail(String email) =>
      _data.users.values.firstWhereOrNull((e) => e.email == email);

  /// Whether the travel document with the given [id] exists.
  bool containsTravelDocument(TravelDocumentId id) =>
      travelDocuments.any((e) => e.tid == id);

  /// Gets the plan with the given [id].
  PlanModel getPlan(String id) =>
      _data.travelDocuments.getOrThrow(TravelDocumentId.plan(id)).asPlan
          as PlanModel;

  /// Saves the travel document [td].
  ///
  /// It overwrites the travel document with the same ID if it exists.
  void saveTravelDocument(TravelDocumentEntity td) {
    _data.travelDocuments.save(td.tid, td);
  }

  /// Deletes the plan with the given [id].
  void deletePlan(String id) {
    _data.travelDocuments.delete(TravelDocumentId.plan(id));
  }

  /// Deletes the travel document with the given [tid].
  void deleteTravelDocument(TravelDocumentId tid) {
    _data.travelDocuments.delete(tid);
  }

  /// Gets the list of all travel documents.
  List<TravelDocumentEntity> get travelDocuments =>
      [..._data.travelDocuments.values];

  /// Gets the list of all plans.
  List<PlanModel> get _plans =>
      _data.travelDocuments.values.whereType<PlanModel>().toList();

  List<PlanModel> get sortedPlans => _plans.sortedByCompare(
        (plan) => plan.plannedAt,
        (p1, p2) {
          if (p2 == null) return -1;
          if (p1 == null) return 1;
          return p1.compareTo(p2);
        },
      );

  /// Gets the list of all plans sorted by the planned date that match
  /// the given [predicate].
  List<PlanModel> getSortedPlansWhere(
    bool Function(PlanModel plan) predicate,
  ) =>
      sortedPlans.where(predicate).toList();

  /// Saves all the travel [items].
  void saveTravelItems(List<TravelItemEntity> items) {
    _data.travelItems.saveAll({
      for (final item in items) item.id: item as TravelItemModel,
    });
  }

  /// Gets the travel item with the given [id].
  TravelItemModel getTravelItem(String id) => _data.travelItems.getOrThrow(id);

  /// Gets the widget with the given [id].
  WidgetModel getWidget(String id) =>
      _data.travelItems.getOrThrow(id) as WidgetModel;

  /// Gets the widget folder with the given [id].
  WidgetFolderModel getWidgetFolder(String id) =>
      _data.travelItems.getOrThrow(id) as WidgetFolderModel;

  /// Gets the widget folder wrapper of the folder with the given [id].
  WidgetFolderEntityWrapper getWidgetFolderWrapper(String id) =>
      getWidgetFolder(id).let(
        (folder) => WidgetFolderEntityWrapper(
          folder,
          _data.travelItems.values
              .where((e) => e.isWidget && e.asWidget.folderId == id)
              .sortedBy<num>((e) => e.order)
              .cast<WidgetEntity>()
              .toList(),
        ),
      );

  /// Gets the travel document wrapper.
  TravelDocumentWrapper<T>
      getTravelDocumentWrapper<T extends TravelDocumentEntity>(
    TravelDocumentId travelDocumentId,
  ) {
    final td = _data.travelDocuments.getOrThrow(travelDocumentId);
    if (td is! T) {
      throw ArgumentError.value(
        travelDocumentId,
        'travelDocumentId',
        'The travel document is not of the expected type $T.',
      );
    }
    final items = _data.travelItems.values
        .where((e) => e.travelDocumentId == travelDocumentId)
        .toList();
    // Items in the root of the travel document.
    final rootItems = items
        .where((e) => e.isFolderWidget || e.asWidget.doesNotBelongToAFolder)
        .sortedBy<num>((e) => e.order)
        .toList();

    // Items in the folders of the travel document.
    final folderItems = items
        .where((e) => !e.isFolderWidget && e.asWidget.belongsToAFolder)
        .toList();

    return TravelDocumentWrapper(
      travelDocument: td,
      travelItems: rootItems
          .map(
            (item) => item.isWidget
                ? TravelItemEntityWrapper.widget(item.asWidget)
                : TravelItemEntityWrapper.folder(
                    item.asFolderWidget,
                    // Get the items of the folder.
                    folderItems
                        .cast<WidgetEntity>()
                        .where((j) => j.asWidget.folderId! == item.id)
                        .sortedBy<num>((e) => e.order)
                        .toList(),
                  ),
          )
          .toList(),
    );
  }
}
