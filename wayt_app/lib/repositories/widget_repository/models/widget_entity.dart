import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:luthor/luthor.dart';

import '../widget_repository.dart';

abstract interface class WidgetEntity
    implements Equatable, UniquelyIdentifiableEntity {
  /// The id of the folder that contains the Widget.
  ///
  /// If the Widget is not in a folder, this value is `null`.
  String? get folderId;

  /// The type of the Widget.
  WidgetType get type;

  /// The features of the Widget.
  List<WidgetFeatureEntity> get features;

  /// Validator for the [folderId].
  static Validator get folderIdValidator => l.string().uuid().required();
}
