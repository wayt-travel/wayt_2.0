import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'widget_folder_icon.gen.g.dart';

/// {@template widget_folder_icon}
/// Model for the Icon of a widget folder.
///
/// It extends [IconData] to represent the icon data so it can be used directly
/// in Flutter widgets.
/// {@endtemplate}
@JsonSerializable()
final class WidgetFolderIcon extends IconData
    with EquatableMixin, ModelToStringMixin
    implements Entity, IModel {
  /// {@macro widget_folder_icon}
  WidgetFolderIcon({
    required int codePoint,
    String? fontFamily,
    String? fontPackage,
    List<String>? fontFamilyFallback,
    bool matchTextDirection = false,
  }) : super(
          codePoint,
          fontFamily: fontFamily,
          fontPackage: fontPackage,
          fontFamilyFallback: fontFamilyFallback,
          matchTextDirection: matchTextDirection,
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

  /// Creates a [WidgetFolderIcon] from a JSON.
  factory WidgetFolderIcon.fromJson(Json json) =>
      _$WidgetFolderIconFromJson(json);

  /// Converts the [WidgetFolderIcon] to a JSON.
  Json toJson() => _$WidgetFolderIconToJson(this);

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
