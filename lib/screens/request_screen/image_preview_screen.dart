import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final String fileName;

  const ImagePreviewScreen({
    super.key,
    required this.imagePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          fileName,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontSize: ResponsiveUtils.sp(16, context),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Hero(
            tag: 'image-$imagePath',
            child: Image.file(File(imagePath), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
