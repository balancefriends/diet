import 'package:diet_image/src/image.dart';
import 'package:restio/restio.dart';
import 'package:uuid/uuid.dart';

const _kDefaultBaseCDN = 'https://ucarecdn.com/';

Uuid _uuid = Uuid();

class UploadcareImageProvider extends DietImageProvider {
  final String baseCdn;

  UploadcareImageProvider(
    String url, {
    String key,
    this.baseCdn = _kDefaultBaseCDN,
  }) : super(url.replaceFirst(_kDefaultBaseCDN, baseCdn), key ??= _uuid.v4()) {}

/*
  factory UploadcareImageProvider.fromUrl(String url) {
    final uri = Uri.parse(url);
    final _baseCdn = '${uri.scheme}://${uri.host}/';
    final _uuid = uri.pathSegments.first;
  }*/
}
