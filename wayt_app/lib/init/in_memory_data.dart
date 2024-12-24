import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:uuid/uuid.dart';

import '../repositories/repositories.dart';

class _Data {
  final Cache<String, PlanModel> plans;

  _Data({required this.plans});
}

class InMemoryData with LoggerMixin {
  final _data = _Data(plans: Cache());

  final _uuid = const Uuid();

  String generateUuid() => _uuid.v4();

  Cache<String, PlanModel> get plans => _data.plans;
  Cache<String, PlanSummaryModel> get plansAsSummary {
    final map = {
      for (final e in _data.plans.entries)
        e.key: PlanSummaryModel(
          createdAt: e.value.createdAt,
          uuid: e.value.uuid,
          isDaySet: e.value.isDaySet,
          isMonthSet: e.value.isMonthSet,
          plannedAt: e.value.plannedAt,
          tags: e.value.tags,
          title: e.value.title,
          updatedAt: e.value.updatedAt,
        )
    };

    return Cache.fromMap(map);
  }
}
