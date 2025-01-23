import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../repositories.dart';

/// Utility class that wraps a [TravelItemEntity].
sealed class TravelItemEntityWrapper with EquatableMixin, ModelToStringMixin {
  /// The item wrapped by this instance.
  final TravelItemEntity value;

  const TravelItemEntityWrapper(this.value);

  /// Creates a new instance of [TravelItemEntityWrapper] with the given values.
  factory TravelItemEntityWrapper.widget(WidgetEntity value) =>
      WidgetEntityWrapper(value);

  /// Creates a new instance of [TravelItemEntityWrapper] with the given values.
  factory TravelItemEntityWrapper.folder(
    WidgetFolderEntity value,
    List<WidgetEntity> children,
  ) =>
      WidgetFolderEntityWrapper(value, children);

  /// Whether the item is a folder.
  @nonVirtual
  bool get isFolderWidget => !isWidget;

  /// Whether the item is a widget.
  bool get isWidget;

  /// Casts the item to a widget wrapper.
  @nonVirtual
  WidgetEntityWrapper get asWidgetWrapper => this as WidgetEntityWrapper;

  /// Casts the item to a folder widget wrapper.
  @nonVirtual
  WidgetFolderEntityWrapper get asFolderWidgetWrapper =>
      this as WidgetFolderEntityWrapper;
}

/// Wrapper for a folder widget.
class WidgetFolderEntityWrapper extends TravelItemEntityWrapper {
  /// The children of the item if it is a folder, otherwise null.
  final List<WidgetEntity> children;

  /// Creates a new instance of [WidgetFolderEntityWrapper] with the given
  /// values.
  const WidgetFolderEntityWrapper(
    WidgetFolderEntity super.value,
    this.children,
  );

  @override
  WidgetFolderEntity get value => super.value.asFolderWidget;

  @override
  Map<String, dynamic> $toMap() => {
        'value': value.toShortString(),
        'children.length': children.length,
      };

  @override
  bool get isWidget => false;

  @override
  List<Object?> get props => [value, children];
}

/// Wrapper for a widget.
class WidgetEntityWrapper extends TravelItemEntityWrapper {
  /// Creates a new instance of [WidgetEntityWrapper] with the given values.
  const WidgetEntityWrapper(WidgetEntity super.value);

  @override
  WidgetEntity get value => super.value.asWidget;

  @override
  Map<String, dynamic> $toMap() => {'value': value.toShortString()};

  @override
  bool get isWidget => true;

  @override
  List<Object?> get props => [value];
}
