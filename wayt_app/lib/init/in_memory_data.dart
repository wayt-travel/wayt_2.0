import 'dart:math';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';
import 'package:world_countries/world_countries.dart';

import '../repositories/repositories.dart';

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
  final Cache<String, TravelItemModel> travelItems;

  _Data({
    required this.users,
    required this.plans,
    required this.travelItems,
  });
}

class InMemoryData with LoggerMixin {
  final _data = _Data(
    users: Cache(),
    plans: Cache(),
    travelItems: Cache(),
  );

  InMemoryData() {
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

  void _addPlans() {
    final countries = [...WorldCountry.list]..shuffle(_rnd);
    const planCount = 20;
    for (final i in List.generate(planCount, (i) => i)) {
      final id = _uuid.v4();
      final country = countries.removeLast();
      final today = DateTime.now().toDate();
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
          tags: ['tag'],
          name: 'Trip to ${country.name.name}',
          itemIds: [],
        ),
      );
    }
  }

  String generateUuid() => _uuid.v4();

  Cache<String, PlanModel> get plans => _data.plans;
  Cache<String, UserModel> get users => _data.users;
  Cache<String, TravelItemModel> get travelItems => _data.travelItems;
  Cache<String, WidgetModel> get widgets => _data.travelItems.entries
      .where((e) => e.value is WidgetModel)
      .map((e) => MapEntry(e.key, e.value as WidgetModel))
      .let(Map.fromEntries)
      .let(Cache.fromMap);
  String get authUserId => _data.authUserId;
  UserModel get authUser => _data.users.getOrThrow(authUserId);
}
