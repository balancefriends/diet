import 'image_format.dart';

/// Base class for accessing the CDN API
abstract class Transformation {
  /// CDN API operation URL directive
  String get operation;

  /// Related parameters
  List<String> get params;
}

/// An abstraction for image transformations
abstract class ImageTransformation implements Transformation {}

/// An abstraction to make transformation implementation with `enum` values
abstract class EnumTransformation<T> extends Transformation {
  final T value;

  EnumTransformation(this.value)
      : assert(value != null, 'Should be non-null enum value');

  String get valueAsString;

  @override
  List<String> get params => [valueAsString];
}

abstract class ImageFormatTransformation
    extends EnumTransformation<ImageFormat> {
  ImageFormatTransformation(ImageFormat value) : super(value);
}
