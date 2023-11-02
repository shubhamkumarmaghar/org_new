import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:partypeoplebusiness/views/login_user/login_screen.dart';
import 'package:partypeoplebusiness/views/onboarding_screens/onboarding_screen.dart';

import '../login_user/user_country_type.dart';
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
    updaterApp();
    Timer(const Duration(seconds: 2), () {
      if ('${GetStorage().read('onboarding')}' == '1') {

        if(GetStorage().read('loggedIn') == '1') {
          Get.offAll(OrganisationDashboard());
        }
        else{
         // Get.offAll(SelectUserCountry());
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

  void updaterApp() async
  {
    await appUpdater();
  }
  Future<void> appUpdater()async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        log('updateInfo.updateAvailability ${updateInfo.updateAvailability}');
        if (updateInfo.immediateUpdateAllowed) {
          log('updateInfo.immediateUpdateAllowed ${updateInfo
              .immediateUpdateAllowed}');
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              log('appUpdateResult ${appUpdateResult}');
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          log('updateInfo.flexibleUpdateAllowed ${updateInfo
              .flexibleUpdateAllowed}');
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              log('appUpdateResult ${appUpdateResult}');
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }

}
