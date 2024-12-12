/// A common parent for models.
abstract interface class ResourceEntity {
  String get uuid;

  DateTime get createdAt;
  DateTime? get updatedAt;
}
