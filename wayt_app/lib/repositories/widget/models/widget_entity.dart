import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../repositories.dart';

/// Interface for a Widget entity.
abstract interface class WidgetEntity
    implements
        TravelItemEntity,
        Equatable,
        UniquelyIdentifiableEntity,
        ModelToStringMixin {
  /// The id of the folder that contains the Widget.
  ///
  /// If the Widget is not in a folder, this value is `null`.
  String? get folderId;

  /// Whether the Widget is within a folder.
  ///
  /// This is `true` if [folderId] is not `null`.
  bool get belongsToAFolder;

  /// Whether the Widget is in the root of the travel document.
  ///
  /// This is `true` if [folderId] is `null`.
  bool get doesNotBelongToAFolder;

  /// The type of the Widget.
  WidgetType get type;

  /// The features of the Widget.
  List<WidgetFeatureEntity> get features;

  /// The version of the widget.
  Version get version;

  @override
  TravelItemEntity copyWith({
    int? order,
    Option<String?> folderId,
  });
}
