import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/organisation/dashboard/organization_dashboard.dart';
import '../views/login_user/login_screen.dart';
import '../views/login_user/user_country_type.dart';

void showLogoutAlertDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Logout ? ',
    desc: 'Are you sure you want to Logout ',
    titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
    descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
    btnOkText: "Log out",
    btnOkOnPress: () {
      GetStorage().remove('token');
      GetStorage().remove('loggedIn');
      //Get.find<OrganizationDashboardController>().timer.cancel();
      Get.offAll(SelectUserCountry());
      //Get.offAll(LoginView());
    },
    btnCancelText: "Cancel",
    btnCancelOnPress: () {
      //  Navigator.pop(context);
    },
  ).show();
}
