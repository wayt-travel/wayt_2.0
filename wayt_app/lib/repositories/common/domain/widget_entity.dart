import 'package:equatable/equatable.dart';

import '../common.dart';

abstract interface class WidgetEntity extends Equatable implements PlanItem {
  String get id;

  // TODO: we want to use the ref id of the folder,
  // or the summary of the folder?
  String? get folderId;
  WidgetType get type;
  List<WidgetFeatureEntity> get features;
}
