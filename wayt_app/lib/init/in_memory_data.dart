import 'dart:math';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
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
  final Cache<String, PlanModel> plans;
  // FIXME: add journals
  final Cache<String, TravelDocument> journals;
  final Cache<String, TravelItemModel> travelItems;

  _Data({
    required this.users,
    required this.plans,
    required this.journals,
    required this.travelItems,
  });
}

class InMemoryDataHelper with LoggerMixin {
  final _data = _Data(
    users: Cache(),
    plans: Cache(),
    journals: Cache(),
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

  void _addWidgets(String planId) {
    final titles = [
      'This is a heading!',
      'Stop #1',
      'Stop #2',
      'Stop #3',
      'Stop #4',
    ];
    var order = 0;
    for (final title in titles) {
      final widgets = [
        TextWidgetModel(
          id: _uuid.v4(),
          order: order++,
          createdAt: DateTime.now().toUtc(),
          travelDocumentId: TravelDocumentId.plan(planId),
          text: title,
          textStyle: const FeatureTextStyle.h1(),
        ),
        TextWidgetModel(
          id: _uuid.v4(),
          order: order++,
          createdAt: DateTime.now().toUtc(),
          travelDocumentId: TravelDocumentId.plan(planId),
          text: 'We plan to visit this place. Here, then there, etc.'
              '\n\n$loremIpsum',
          textStyle: const FeatureTextStyle.body(),
        ),
      ];
      _data.travelItems.saveAll({
        for (final widget in widgets) widget.id: widget,
      });
    }
  }

  void _addPlans() {
    final countries = [...WorldCountry.list]..shuffle(_rnd);
    const planCount = 20;
    for (final i in List.generate(planCount, (i) => i)) {
      final id = _uuid.v4();
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
      _data.plans.save(
        id,
        PlanModel(
          userId: _data.authUserId,
          createdAt: DateTime.now().toUtc(),
          id: id,
          isMonthSet: isMonthSet,
          isDaySet: isDaySet,
          plannedAt: isYearSet ? plannedAt : null,
          tags: [country.name.name],
          name: 'Trip to ${country.name.name}',
          updatedAt: null,
        ),
      );
      _addWidgets(id);
    }
  }

  String generateUuid() => _uuid.v4();

  String get authUserId => _data.authUserId;

  UserModel get authUser => _data.users.getOrThrow(authUserId);

  UserModel getUser(String id) => _data.users.getOrThrow(id);

  UserModel? tryGetUserByEmail(String email) =>
      _data.users.values.firstWhereOrNull((e) => e.email == email);

  bool containsTravelDocument(TravelDocumentId id) =>
      travelDocuments.any((e) => e.tid == id);

  PlanModel getPlan(String id) => _data.plans.getOrThrow(id);

  void savePlan(PlanModel plan) {
    _data.plans.save(plan.id, plan);
  }

  void deletePlan(String id) {
    _data.plans.delete(id);
  }

  List<TravelDocument> get travelDocuments => [
        ..._data.plans.values,
        ..._data.journals.values,
      ];

  List<PlanModel> get plans => _data.plans.values.toList();

  List<PlanModel> getPlansWhere(bool Function(PlanModel plan) predicate) =>
      _data.plans.values.where(predicate).sortedByCompare(
        (plan) => plan.plannedAt,
        (p1, p2) {
          if (p2 == null) return -1;
          if (p1 == null) return 1;
          return p1.compareTo(p2);
        },
      );

  void saveTravelItems(List<TravelItemModel> items) {
    _data.travelItems.saveAll({
      for (final item in items) item.id: item,
    });
  }

  TravelItemModel getTravelItem(String id) => _data.travelItems.getOrThrow(id);

  WidgetModel getWidget(String id) =>
      _data.travelItems.getOrThrow(id) as WidgetModel;

  WidgetFolderModel getWidgetFolder(String id) =>
      _data.travelItems.getOrThrow(id) as WidgetFolderModel;

  List<WidgetModel> getWidgetsOfTravelDocument(
    TravelDocumentId travelDocumentId,
  ) =>
      getTravelItemsOfTravelDocument(travelDocumentId)
          .whereType<WidgetModel>()
          .toList();

  List<TravelItemModel> getTravelItemsOfTravelDocument(
    TravelDocumentId travelDocumentId,
  ) =>
      _data.travelItems.values
          .where((e) => e.travelDocumentId == travelDocumentId)
          .sortedBy<num>((e) => e.order)
          .toList();
}
