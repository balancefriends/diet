// ignore: implementation_imports
import 'package:cached_network_image/src/image_provider/_image_provider_io.dart';
import 'package:diet_image/src/uploadcare/uploadcare_image.dart';
import 'package:flutter/widgets.dart';
import 'package:octo_image/octo_image.dart';
import 'package:uuid/uuid.dart';

typedef DietImageBuilder = Widget Function(BuildContext context, Widget child);
typedef DietPlaceholderBuilder = Widget Function(BuildContext context);
typedef DietProgressIndicatorBuilder = Widget Function(
  BuildContext context,
  ImageChunkEvent progress,
);
typedef DietErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

enum ImageCDNProvider {
  UPLOADCARE,
  IMGIX,
  CONTENTFUL,
  OTHER,
}

Uuid _uuid = Uuid();

/// DietImage can be used as a replacement of [Image]. It can be used with any
/// [ImageProvider], but works best with [CachedNetworkImageProvider](https://pub.dev/packages/cached_network_image).
/// DietImage can show a placeholder or progress and an error. It can also do
/// transformations on the shown image.
/// This all can be simplified by using a complete [OctoSet] with predefined
/// combinations of [OctoPlaceholderBuilder], [DietImageBuilder] and
/// [OctoErrorBuilder].
class DietImage extends StatefulWidget {
  /// The image that should be shown.
  final String imageUrl;
  final String imageKey;
  final bool reloadOnTab;
  final bool reloadOnError;
  final ImageCDNProvider cdnProvider;
  DietErrorBuilder errorBuilder;

  DietImage(
    this.imageUrl, {
    Key key,
    this.cdnProvider = ImageCDNProvider.OTHER,
    String imageKey,
    this.reloadOnTab = false,
    this.reloadOnError = false,
    DietImageBuilder imageBuilder,
    DietPlaceholderBuilder placeholderBuilder,
    DietProgressIndicatorBuilder progressIndicatorBuilder,
    this.errorBuilder,
    Duration fadeInDuration,
    Curve fadeInCurve,
    int width,
    int height,
    BoxFit fit,
    Alignment alignment,
    ImageRepeat repeat,
    bool matchTextDirection,
    Color color,
    FilterQuality filterQuality,
    BlendMode colorBlendMode,
    Duration placeholderFadeInDuration,
    bool gaplessPlayback,
    int memCacheWidth,
    int memCacheHeight,
  })  : imageKey = imageKey ?? _uuid.v4(),
        super(
          key: key,
        );

  void reload() {}

  @override
  State<StatefulWidget> createState() => _DietImageState();
}

class _DietImageState extends State<DietImage> {
  String _reloadKey;

  @override
  void initState() {
    _reloadKey = widget.imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider _imageProvider;

    switch (widget.cdnProvider) {
      case ImageCDNProvider.UPLOADCARE:
        _imageProvider = UploadcareImageProvider(widget.imageUrl);
        break;
      case ImageCDNProvider.IMGIX:
      // TODO: Handle this case.

      case ImageCDNProvider.CONTENTFUL:
      // TODO: Handle this case.
      case ImageCDNProvider.OTHER:
        // TODO: Handle this case.
        _imageProvider = DietImageProvider(widget.imageUrl, _reloadKey);
        break;
    }
    return GestureDetector(
      onTap: _reload,
      child: OctoImage(
        key: ValueKey(_reloadKey),
        image: _imageProvider,
        errorBuilder: widget.errorBuilder,
      ),
    );
  }

  void _reload() {
    if (widget.reloadOnTab) {
      setState(() {
        _reloadKey = _uuid.v4();
      });
    }
  }
}

class DietImageProvider extends CachedNetworkImageProvider {
  final key;

  DietImageProvider(String url, this.key) : super(url);

  factory DietImageProvider.uploadcare(String url, String key) {
    return UploadcareImageProvider(url, key: key);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DietImageProvider &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => super.hashCode ^ key.hashCode;
}
