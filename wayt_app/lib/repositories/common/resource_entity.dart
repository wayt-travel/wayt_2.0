/// A common parent for models.
abstract interface class ResourceEntity {
  String get id;

  DateTime get createdAt;
  DateTime? get updatedAt;
}
