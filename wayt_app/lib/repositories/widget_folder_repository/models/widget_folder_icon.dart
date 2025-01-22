import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

/// Model for the Icon of a folder.
final class WidgetFolderIcon extends Model
    with EquatableMixin
    implements IModel {
  /// The code of the icon.
  final int code;

  /// The font family of the icon.
  final String fontFamily;

  WidgetFolderIcon({
    required this.code,
    required this.fontFamily,
  });

  @override
  List<Object?> get props => [code, fontFamily];

  @override
  Map<String, dynamic> $toMap() => {
        'code': code,
        'fontFamily': fontFamily,
      };
}
