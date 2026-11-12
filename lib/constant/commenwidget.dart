import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void mySnakBar({
  required String title,
  required String msg,
  required int second,
  required Color color,
}) {
  Get.snackbar(
    title,
    msg,
    backgroundColor: color,
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: second),
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
  );
}

Widget imageHandel({
  String? image,
  required double height,
  required double width,
  required BoxShape shape,
}) {
  return CachedNetworkImage(
    httpHeaders: {'Cookie': 'session_id=${AppConstant.client.sessionId!.id}'},
    imageUrl:
        image ??
        'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 2),
        shape: shape,
        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
      ),
    ),
    placeholder: (context, url) =>
        Center(child: SpinKitThreeBounce(color: Colors.grey[300])),
    errorWidget: (context, url, error) => CachedNetworkImage(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}
