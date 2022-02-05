import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageWidget extends ClipRRect {
  final String imageUrl;
  const CircleImageWidget({Key? key, this.imageUrl = ""}) : super(key: key);

  static final _placeHolder = Container(
    color: Colors.grey.shade400,
  );

  @override
  BorderRadius? get borderRadius => BorderRadius.circular(100);
  @override
  Widget? get child => CachedNetworkImage(
        placeholder: (context, url) => _placeHolder,
        errorWidget: (context, url, error) => _placeHolder,
        imageUrl: imageUrl,
        fit: BoxFit.fill,
      );
}
