import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/repositories/repositories.dart';
import 'package:wayt_app/util/util.dart';

class DummyTestData {
  final TravelDocumentId travelDocumentId;

  DummyTestData(this.travelDocumentId);

  TextWidgetModel buildTextWidget({
    String? id,
    String? folderId,
    TravelDocumentId? travelDocumentId,
    int order = 0,
  }) =>
      TextWidgetModel(
        id: id ?? const Uuid().v4(),
        text: 'Dummy',
        order: order,
        textStyle: const TypographyFeatureStyle.body(),
        travelDocumentId: travelDocumentId ?? this.travelDocumentId,
        folderId: folderId,
      );

  WidgetFolderEntity buildFolderWidget({
    TravelDocumentId? travelDocumentId,
    String? id,
    int order = 0,
  }) =>
      WidgetFolderModel(
        id: id ?? const Uuid().v4(),
        name: 'Dummy',
        order: order,
        travelDocumentId: travelDocumentId ?? this.travelDocumentId,
        color: FeatureColor.amber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
      );

  PhotoWidgetModel buildPhotoWidget({
    String? id,
    TravelDocumentId? travelDocumentId,
    String? folderId,
    int order = 0,
  }) =>
      PhotoWidgetModel(
        id: id ?? const Uuid().v4(),
        order: order,
        travelDocumentId: travelDocumentId ?? this.travelDocumentId,
        mediaExtension: '.jpg',
        folderId: folderId,
        byteCount: 1000,
        mediaId: const Uuid().v4(),
        size: const IntSize.square(256),
        takenAt: null,
        url: null,
        latLng: null,
      );
}
