import '../common.dart';

class WidgetFeatureModel implements WidgetFeatureEntity {
  @override
  final int index;

  @override
  final WidgetFeatureType type;

  WidgetFeatureModel({required this.index, required this.type});
}
