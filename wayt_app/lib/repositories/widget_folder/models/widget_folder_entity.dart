import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

import '../../../util/util.dart';
import '../../repositories.dart';

/// Entity for a folder of widgets in a travel plan or journal.
abstract interface class WidgetFolderEntity
    implements
        TravelItemEntity,
        Equatable,
        UniquelyIdentifiableEntity,
        ModelToStringMixin {
  /// The name of the folder.
  String get name;

  /// Returns a validator for the name of the folder.
  static Validator getNameValidator(BuildContext? context) =>
      Validators.l10n(context).textShortRequired();

  /// The icon of the folder.
  WidgetFolderIcon get icon;

  /// The color of the folder.
  FeatureColor get color;
}
