import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/cached_image_placeholder.dart';

class CustomImageSlider extends StatelessWidget {
  String partyPhotos;
  String imageStatus;
  CustomImageSlider({super.key,required this.partyPhotos, required this.imageStatus});

  @override
  Widget build(BuildContext context) {
    return
      Blur(blur: 5.0,
        child: Container(
          height: Get.height*0.4,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15),
            // image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.cover),
          ),
          width: Get.width,
          child: CachedNetworkImageWidget(
            imageUrl: partyPhotos,
            fit: BoxFit.fill,
            height: Get.height*0.4,
            width: Get.width,
            errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade400,
              period: const Duration(milliseconds: 1500),
              child:  Container(
                height: Get.height * 0.4,
                color: Color(0xff7AB02A),
              ),
            ),
          ),
        ),
        overlay:imageStatus =='1' ?Container(
          height: Get.height*0.4,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15),
            // image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.cover),
          ),
          child: CachedNetworkImageWidget(
            imageUrl: partyPhotos,
            fit: BoxFit.fill,
            height: Get.height*0.4,
            width: Get.width,
            errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline),
            placeholder: (context, url) =>Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade400,
              period: const Duration(milliseconds: 1500),
              child:  Container(
                height: Get.height * 0.4,
                color: Color(0xff7AB02A),
              ),
            ),
          ),
          width: Get.width,
        ):Container() ,
      );
  }
}

class ProfileImageWithStatus {
  String image;
  String status;
  ProfileImageWithStatus({required this.image,required this.status});
}