import 'package:flutter/material.dart';
import 'package:get/get.dart';

double get getScreenHeight => Get.size.height;

double get getScreenWidth => Get.size.width;

Widget getBackBarButton({required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: getScreenWidth*0.025,bottom: getScreenHeight*0.005),
        child: CircleAvatar(
          child: Icon(
            Icons.arrow_back,
            color: Colors.red.shade900,
          ),
          backgroundColor: Colors.grey.shade200,
        )),
  );
}