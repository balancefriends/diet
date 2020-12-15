import 'package:diet_image/src/cdn_operation.dart';

import '../image_format.dart';

/// Base class for accessing the Uploadcare CDN API
abstract class UploadcareTransformation with Transformation {
  /// CDN API operation URL directive
  String get operation;

  /// Related parameters
  List<String> get params;

  /// Instruction delimiter
  String get delimiter => '-/';

  @override
  String toString() => [operation, ...params].join('/');

  bool operator ==(dynamic other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Convert an image to one of the supported output formats: [ImageFormatTValue]
class UploadcareImageFormatTransformation extends ImageFormatTransformation
    implements ImageTransformation {
  UploadcareImageFormatTransformation(ImageFormat value) : super(value);

  @override
  String get valueAsString {
    switch (value) {
      case ImageFormat.AUTO:
        return 'auto';
      case ImageFormat.JPEG:
        return 'jpeg';
      case ImageFormat.PNG:
        return 'png';
      case ImageFormat.WEBP:
        return 'webp';
      default:
        return '';
    }
  }

  @override
  String get operation => 'format';
}
