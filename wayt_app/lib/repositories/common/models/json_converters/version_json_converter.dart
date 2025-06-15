import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

/// {@template version_json_converter}
/// A JSON converter for [Version] objects.
///
/// This converter serializes [Version] objects to a JSON map and vice versa.
/// {@endtemplate}
class VersionJsonConverter
    extends JsonConverter<Version, Map<String, dynamic>> {
  /// {@macro version_json_converter}
  const VersionJsonConverter();

  @override
  Version fromJson(Map<String, dynamic> json) =>
      Version.parse(json['version'] as String);

  @override
  Map<String, dynamic> toJson(Version object) =>
      {'version': object.canonicalizedVersion};
}
