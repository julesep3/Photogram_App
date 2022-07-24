import 'package:flutter/material.dart';

class WebImage extends Image {
  WebImage({
    required String url,
    required BuildContext context,
    double height = 300.0,
    double width = 300.0,
  }) : super.network(
          url,
          height: height,
          width: width,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(
              Icons.error,
              size: height,
            );
          },
          // while image is downloading, loadingBuilder is called (progress)
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null)
              return child;
            else
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
          },
        );
}
