import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final PlaceholderWidgetBuilder placeholder;
  var errorWidget;

  CachedNetworkImageWidget({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          placeholder, // ?? (context, url) => CircularProgressIndicator(),
      errorWidget: errorWidget ??
          (context, url, error) => Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
    );
  }
}
