import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPage extends StatelessWidget {
  final List urls;
  GalleryPage({this.urls});
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(itemCount: urls.length,
        builder: (context, index){
          return PhotoViewGalleryPageOptions(
            imageProvider: urls[index],
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor
        ),

      );

  }
}
