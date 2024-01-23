import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../controller/login_controller/login_controller.dart';
import '../organization/profile_preview/profile_preview.dart';

class ForgotUserName extends StatefulWidget {
  ForgotUserName({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotUserName> createState() => _ForgotUserNameState();
}

class _ForgotUserNameState extends State<ForgotUserName> {
  String countryType = '1';

  LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: Get.height,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, 0.0),
          radius: 0.424,
          colors: [Color(0xffb11212), Color(0xff2e0303)],
          stops: [0.0, 1.0],
          transform: GradientXDTransform(
              0.0, -1.0, 1.23, 0.0, -0.115, 1.0, Alignment(0.0, 0.0)),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: Obx(
                () => Container(
                  child: Stack(children: [
                    Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'User Name',
                            style: TextStyle(
                              fontFamily: 'malgun',
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              letterSpacing: -0.36.sp,
                              fontWeight: FontWeight.w700,
                              height: 0.9444444444444444,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 55,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21.0),
                            color: const Color(0xffffffff),
                            border: Border.all(
                                width: 0.2, color: const Color(0xff707070)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x21329d9c),
                                offset: Offset(0, 13),
                                blurRadius: 34,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: TextField(
                              maxLines: 1,
                              controller: controller.forgotMobileNumber,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color(0xff707070),
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter Mobile Number or Email',
                                hintStyle: TextStyle(
                                    fontFamily: 'malgun', fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        controller.isLoading.value == true
                            ? Container(
                                child: const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (controller.forgotMobileNumber.text.isNotEmpty) {
                                    controller.forgotPassword();
                                  } else {
                                    Get.snackbar('Field is Empty',
                                        'Please fill the field');
                                  }
                                },
                                child: Container(
                                  width: Get.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xffFF4D4D),
                                        Color(0xffFF0000),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Submit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 6,
                              width: 51,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: const Color(0xffFFA914),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'By creating an account, you agree to our \nTerms of Service and Privacy Policy',
                              style: TextStyle(
                                fontFamily: 'malgun',
                                fontSize: 8.sp,
                                color: Colors.grey.shade300,
                                letterSpacing: -0.2,
                                height: 1.4,
                              ),
                              textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
