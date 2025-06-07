import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:intl/intl.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../repositories/repositories.dart';

/// Exif type alias.
typedef Exif = Map<String?, IfdTag>;

/// Helper class to read and parse EXIF metadata from images.
class ExifHelper {
  static const _logger = NthLogger('ExifHelper');

  /// The EXIF metadata read from the image file or bytes.
  final Exif metadata;
  LatLng? _latLng;
  DateTime? _dateTime;

  ExifHelper._(this.metadata);

  /// Creates an instance of [ExifHelper] from a file.
  ///
  /// The file is read and the EXIF metadata is extracted from its bytes.
  static Future<ExifHelper?> maybeFromFile(File file) async {
    try {
      return ExifHelper._(await readExifFromFile(file));
    } catch (e, s) {
      _logger.e('Error when reading exif from file $e', e, s);
      return null;
    }
  }

  /// Creates an instance of [ExifHelper] from bytes.
  static Future<ExifHelper?> maybeFromBytes(Uint8List bytes) async {
    try {
      return ExifHelper._(await readExifFromBytes(bytes));
    } catch (e, s) {
      _logger.e('Error when reading exif from bytes $e', e, s);
      return null;
    }
  }

  /// Whether the EXIF metadata contains GPS (geolocation) tags.
  bool get hasGeoTag =>
      metadata.containsKey('GPS GPSLatitude') &&
      metadata.containsKey('GPS GPSLongitude') &&
      metadata.containsKey('GPS GPSLatitudeRef') &&
      metadata.containsKey('GPS GPSLongitudeRef');

  /// The latitude and longitude of the image, if available.
  LatLng? get latLng {
    if (!hasGeoTag) return null;

    if (_latLng != null) return _latLng;

    final latitudeValue = metadata['GPS GPSLatitude']!
        .values
        .toList()
        .cast<Ratio>()
        .map<double>(
          (item) => item.numerator.toDouble() / item.denominator.toDouble(),
        )
        .toList();
    final latitudeSignal = metadata['GPS GPSLatitudeRef']?.printable;

    final longitudeValue = metadata['GPS GPSLongitude']!
        .values
        .toList()
        .cast<Ratio>()
        .map<double>(
          (item) => item.numerator.toDouble() / item.denominator.toDouble(),
        )
        .toList();
    final longitudeSignal = metadata['GPS GPSLongitudeRef']?.printable;

    var latitude =
        latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    var longitude = longitudeValue[0] +
        (longitudeValue[1] / 60) +
        (longitudeValue[2] / 3600);

    if (longitude.isNaN || latitude.isNaN) {
      return null;
    }

    if (latitude == 0 && longitude == 0) {
      return null;
    }

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    return _latLng = LatLng(latitude, longitude);
  }

  /// Whether the EXIF metadata contains a date and time tag.
  bool get hasDateTime => metadata.containsKey('EXIF DateTimeOriginal');

  /// The date and time when the image was created, if available.
  DateTime? get dateTime {
    if (!hasDateTime) return null;
    if (_dateTime != null) return _dateTime;
    final dt = DateFormat('yyyy:MM:dd HH:mm:ss');
    try {
      // Extract the localDateTime when the file was created.
      // For photos it is the time of the mobile phone when the photo was
      // taken.
      return _dateTime = dt.parse(
        metadata['EXIF DateTimeOriginal']!.printable,
      );
    } catch (e, s) {
      final msg = 'Impossible to parse ${metadata['EXIF DateTimeOriginal']}'
          ' to DateTime';
      _logger.e(msg, e, s);
    }
    return null;
  }
}
