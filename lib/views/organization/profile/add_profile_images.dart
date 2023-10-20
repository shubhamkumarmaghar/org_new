import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/cached_image_placeholder.dart';
import '../../../controller/organisation/create_profile_controller/create_profile_controller.dart';
import '../../../default_controller.dart';

class AddImageProfile extends StatefulWidget {
  const AddImageProfile({super.key});

  @override
  State<AddImageProfile> createState() => _AddImageProfileState();
}

class _AddImageProfileState extends State<AddImageProfile> {
  CreteOrganisationProfileController controller = Get.find();
  DefaultController defaultController = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body:
    Container(margin: EdgeInsets.all(10),child:
    Column(
      children: [
       /* GestureDetector(
      onTap: () {
        defaultController.defaultControllerType.value = 0;
        controller.showSelectPhotoOptionsTimeline(context);
      },
      child: Obx(
            () => Stack(
          children: [
            SizedBox(
              height: Get.height*0.25,
              width: double.maxFinite,
              child: controller.timeline.value != ''
                  ? controller.isLoading.value == true
                  ? const Center(
                  child: CupertinoActivityIndicator(
                    radius: 15,
                    color: Colors.black,
                  ))
                  : Card(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),),
                  child: ClipRRect(borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImageWidget(
                        imageUrl:
                        controller.timeline.value,
                        width: Get.width,
                        height: Get.height*0.25,
                        fit: BoxFit.fill,
                        errorWidget:
                            (context, url, error) =>
                        const Icon(
                            Icons.error_outline),
                        placeholder: (context, url) =>
                        const Center(
                            child:
                            CupertinoActivityIndicator(
                                color:
                                Colors.black,
                                radius: 15))),
                  ))
                  : Card(
                child: Lottie.asset(
                  'assets/127619-photo-click.json',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  defaultController
                      .defaultControllerType.value = 0;
                  controller
                      .showSelectPhotoOptionsTimeline(context);
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              bottom: 10,
              right: 10,
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    size: 30,
                    Icons.camera_alt,
                    color: Colors.red,
                  )),
            ),
          ],
        ),
      ),
    ),*/
        SizedBox(
          height: Get.height*0.05,
        ),
        Row(
          children: [
            GestureDetector(onTap: (){Navigator.pop(context);},
              child: Container(alignment: Alignment.bottomLeft,
                  child: CircleAvatar(child: Icon(Icons.arrow_back,color: Colors.red.shade900,),
                    backgroundColor: Colors.grey.shade200,)),
            ),
            const SizedBox(
              width: 20,
            ),
            Text('Add more Images',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
       GestureDetector(
         onTap: () {
          // defaultController.defaultControllerType.value = 0;
           controller.profilePhotoSelectNo.value=1;
           controller.showSelectPhotoOptionsProfileImages(context);
         },
         child: Obx(
                 () =>
       customAddImage(imageFile: controller.imageProfile_b, imageUrl: controller.profileB.value)
    ),),
       GestureDetector(
         onTap: () {
          // defaultController.defaultControllerType.value = 0;
           controller.profilePhotoSelectNo.value=2;
           controller.showSelectPhotoOptionsProfileImages(context);
         },
         child: Obx(
                 () =>
                 customAddImage(imageFile: controller.imageProfile_c, imageUrl: controller.profileC.value)
         ),),
     ],),
        SizedBox(height: 20,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          GestureDetector(
            onTap: () {
              //defaultController.defaultControllerType.value = 0;
              controller.profilePhotoSelectNo.value=3;
              controller.showSelectPhotoOptionsProfileImages(context);
            },
            child: Obx(
                    () =>
                    customAddImage(imageFile: controller.imageProfile_d, imageUrl: controller.profileD.value)
            ),),
          GestureDetector(
            onTap: () {
              //defaultController.defaultControllerType.value = 0;
              controller.profilePhotoSelectNo.value=4;
              controller.showSelectPhotoOptionsProfileImages(context);
            },
            child: Obx(
                    () =>
                    customAddImage(imageFile: controller.imageProfile_e, imageUrl: controller.profileE.value)
            ),),
        ],),
    ],)),);
  }

  customAddImage({required File imageFile ,required String imageUrl }){
    return Stack(
      children: [
        controller.isLoading.value == false
            ? Container(
          height: Get.height*0.25,
          width: Get.height*0.21,
          child: imageUrl.isNotEmpty && imageFile.path.isEmpty
              ? Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImageWidget(
                  imageUrl: imageUrl,
                  width: Get.height*0.12,
                  height: Get.height*0.12,
                  fit: BoxFit.fill,
                  errorWidget: (context, url,
                      error) =>
                   Center(
                    child:  Lottie.asset(
                      'assets/127619-photo-click.json',
                    ),),
                  placeholder: (context, url) =>
                  const Center(
                      child:
                      CupertinoActivityIndicator(
                          color: Colors
                              .black,
                          radius: 15))
              ),
          )
              : imageFile.path.isEmpty ?
          Lottie.asset(
            'assets/127619-photo-click.json',
          ):Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),clipBehavior: Clip.hardEdge,
              child: Image.file(imageFile)
          ),
        )
            : Container(
          child: const Center(
            child: CupertinoActivityIndicator(
              radius: 15,
              color: Colors.black,
            ),
          ),
        ),
      /*  Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            child: IconButton(
              onPressed: () {
                defaultController
                    .defaultControllerType.value = 2;
                // _showSelectPhotoOptionsProfile(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),*/
      ],
    );
  }
}
