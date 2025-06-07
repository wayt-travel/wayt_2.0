import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories.dart';

/// Wrapper for a [TravelDocumentEntity] with its [TravelItemEntityWrapper]s.
class TravelDocumentWrapper<T extends TravelDocumentEntity>
    with EquatableMixin, ModelToStringMixin
    implements IModel {
  /// The travel document.
  final T travelDocument;

  /// The travel items of the travel document.
  final List<TravelItemEntityWrapper> travelItems;

  /// Creates a new instance of [TravelDocumentWrapper].
  TravelDocumentWrapper({
    required this.travelDocument,
    required this.travelItems,
  });

  /// Returns the id of the travel document.
  TravelDocumentId get id => travelDocument.tid;

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'travelItems.length': travelItems.length,
      };

  @override
  List<Object?> get props => [travelDocument, travelItems];

  /// Returns the travel items flattened.
  ///
  /// The order in this list is meaningless. Sorting this list does not make
  /// sense too!
  List<TravelItemEntity> get travelItemsFlattened => travelItems
      .flatMap(
        (e) => [
          e.value,
          if (e.isFolderWidget) ...e.asFolderWidgetWrapper.children,
        ],
      )
      .toList();

  /// Returns the travel items in the root of the travel document.
  ///
  /// The order of the items in this list is meaningful.
  List<TravelItemEntity> get rootTravelItems =>
      travelItems.map((e) => e.value).toList();

  /// Returns the travel items that are widgets either in the root or in
  /// folders.
  ///
  /// The order in this list is meaningless. Sorting this list does not make
  /// sense too!
  ///
  /// It does not return the folders.
  List<TravelItemEntity> get onlyWidgets =>
      travelItemsFlattened.whereType<TravelItemEntity>().toList();

  /// Returns all the features of the widgets in the travel document.
  List<WidgetFeatureEntity> get allFeatures =>
      travelItems.map((e) => e.allFeatures).expand((e) => e).toList();
}
