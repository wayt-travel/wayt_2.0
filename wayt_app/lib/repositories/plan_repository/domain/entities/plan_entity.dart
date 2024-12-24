import 'package:equatable/equatable.dart';

import '../../../common/common.dart';
import '../domain.dart';

abstract interface class IPlanEntity extends Equatable
    implements ResourceEntity {
  IPlanEntity copyWith();
}

abstract interface class PlanEntity extends PlanSummaryEntity {
  List<PlanItem> get widgets;
}
