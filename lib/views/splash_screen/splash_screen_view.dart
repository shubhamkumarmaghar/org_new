import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeoplebusiness/views/login_user/login_screen.dart';
import 'package:partypeoplebusiness/views/onboarding_screens/onboarding_screen.dart';

import '../organization/dashboard/organisation_dashboard.dart';

class SplashScreenMain extends StatefulWidget {
  const SplashScreenMain({Key? key}) : super(key: key);

  @override
  State<SplashScreenMain> createState() => _SplashScreenMainState();
}

class _SplashScreenMainState extends State<SplashScreenMain> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if ('${GetStorage().read('onboarding')}' == '1') {

        if(GetStorage().read('loggedIn') == '1') {
          Get.offAll(OrganisationDashboard());
        }
        else{
           Get.offAll(LoginView());
      }
      }
      else {
        Get.offAll(OnBoardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          height: Get.height,
          width: Get.width,
          child: Image.asset(
            'assets/splashscreen.png',
            fit: BoxFit.fill,
          )),
    );
  }
}
