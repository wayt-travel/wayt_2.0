import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template widget_folder_icon}
/// Model for the Icon of a widget folder.
/// 
/// It extends [IconData] to represent the icon data so it can be used directly
/// in Flutter widgets.
/// {@endtemplate}
final class WidgetFolderIcon extends IconData
    with EquatableMixin, ModelToStringMixin
    implements Entity, IModel {
  /// {@macro widget_folder_icon}
  WidgetFolderIcon({
    required int codePoint,
    String? fontFamily,
  }) : super(
          codePoint,
          fontFamily: fontFamily,
        );

  /// Creates a [WidgetFolderIcon] from an [IconData] object.
  WidgetFolderIcon.fromIconData(IconData iconData)
      : super(
          iconData.codePoint,
          fontFamily: iconData.fontFamily,
          fontPackage: iconData.fontPackage,
          fontFamilyFallback: iconData.fontFamilyFallback,
          matchTextDirection: iconData.matchTextDirection,
        );

  @override
  List<Object?> get props => [
        codePoint,
        fontFamily,
        fontFamilyFallback,
        fontPackage,
        matchTextDirection,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        'codePoint': codePoint,
        'fontFamily': fontFamily,
        'fontPackage': fontPackage,
      };
}
