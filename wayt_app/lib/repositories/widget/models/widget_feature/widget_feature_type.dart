/// The type of a Widget feature.
enum WidgetFeatureType {
  /// A typography feature.
  typography,

  /// A geo(graphic) feature.
  geo,

  /// A media feature.
  media,

  /// A means of transport feature.
  meansOfTransport,

  /// A price feature.
  price,

  /// A crono (time) feature.
  crono;

  /// Factory constructor that creates a [WidgetFeatureType] from its
  /// string name.
  factory WidgetFeatureType.fromName(String name) => values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw ArgumentError.value(name, 'name', 'Invalid name'),
      );
}
