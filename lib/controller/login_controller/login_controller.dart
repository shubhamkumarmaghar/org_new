import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeoplebusiness/constants/const_strings.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';
import 'package:partypeoplebusiness/views/organization/profile/create_organisation_profile.dart';

import '../../views/login_user/otp_screen.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;
  TextEditingController username = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  RxBool isLoading = false.obs;
  RxString OTPCodeValue = ''.obs;
  RxString deviceToken = ''.obs;

  ///Use this function to verify phone number and send otp
  Future verifyPhone({required type}) async {
    print('API started');
    if (mobileNumber.text.isPhoneNumber || emailAddress.text.isEmail) {
      isLoading.value = true;

      if(Platform.isIOS) {
        await FirebaseMessaging.instance.getAPNSToken().then((token) {
          print("token is $token");
          deviceToken.value = token!;
        });
      }
      else{
        await FirebaseMessaging.instance.getToken().then((token) {
          print("token is $token");
          deviceToken.value = token!;
        });
      }

      http.Response response = await http
          .post(Uri.parse(API.login), body: {
            if(type =='1') 'phone': mobileNumber.text,
            if(type =='2') 'email': emailAddress.text,
        'username': username.text,
        'device_token': deviceToken.value,
        'user_type':'Organization',
        'type':type
      });
      print('$response');
      print('API started');

      dynamic json = jsonDecode(response.body);
      log('${json}  ${response.body}');
      if (json['status'] == 0) {
        Get.snackbar('Error', 'Username or Mobile Number is not matching',
            backgroundColor: Colors.white);
      } else {
        await GetStorage().write('token', json['data']['token'].toString());

        Get.snackbar('OTP', 'OTP Sent Successfully',
            backgroundColor: Colors.white);
        print('User Token Authentication => ${json['data']['token']}');
        print(GetStorage().read('token'));
        Get.to(OTPScreen(countryType: type,));
      }

      isLoading.value = false;
    }
  }

  ///Check weather user has already filled the data or not
  getAPIOverview() async {
    isLoading.value = true;
    try {
      http.Response response = await http.post(
          Uri.parse(API.organizationDetails),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });
      print("response of Organization ${response.body}");

      if (jsonDecode(response.body)['message'] == 'Organization Data Found.') {
        GetStorage().write('loggedIn', '1');
        log(GetStorage().read('loggedIn'));
        isLoading.value = false;
        Get.offAll(OrganisationDashboard());
      } else {
        isLoading.value = false;
        Get.offAll(CreateOrganisationProfile());
      }
    } on Exception catch (e) {
      print('Exception in Login View ${e}');
    }
    isLoading.value = false;
  }

  ///Use this function to verify sent otp and proceed to new screen
  verifyOTP(String otpValue, BuildContext context) async {
    isLoading.value = true;
    http.Response response = await http.post(
        Uri.parse(
          API.otp,
        ),
        body: {
          'otp': otpValue,
          'user_type' : 'Organization'
        },
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        });
    print(
        "Checking Authorization User Token => '${GetStorage().read('token')}',");
    var json = jsonDecode(response.body);
    isLoading.value = false;

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar('OTP', '${json['message']}', backgroundColor: Colors.white);
      if (json['message'].contains('successfully'.toUpperCase()) ||
          json['message'].contains('successfully'.toLowerCase())) {
        if (kDebugMode) {
          print('Json Data For OTP VERIFICATION FUNC :: $json');
        }
        GetStorage().write('username', username.text);

        await getAPIOverview();
      }
    } else {
      isLoading.value = false;
      Get.snackbar('OTP', '${json['message']}');
    }
    isLoading.value = false;
  }
}
