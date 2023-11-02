import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:partypeoplebusiness/controller/login_controller/login_controller.dart';
import 'package:sizer/sizer.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  LoginController controller = Get.put(LoginController());

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
                              controller: controller.username,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color(0xff707070),
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter Username',
                                hintStyle: TextStyle(
                                    fontFamily: 'malgun', fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Mobile Number',
                            style: TextStyle(
                              fontFamily: 'malgun',
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              letterSpacing: -0.36,
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
                              width: 0.2,
                              color: const Color(0xff707070),
                            ),
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
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/indian_flag.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+91',
                                  style: TextStyle(
                                    color: const Color(0xff707070),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: controller.mobileNumber,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Mobile Number',
                                      hintStyle: TextStyle(
                                        fontFamily: 'malgun',
                                        letterSpacing: -0.36.sp,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
/*
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email Id',
                            style: TextStyle(
                              fontFamily: 'malgun',
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              letterSpacing: -0.36,
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
                              width: 0.2,
                              color: const Color(0xff707070),
                            ),
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
                            child: Row(
                              children: [
                               // const SizedBox(width: 8),
                               /* Text(
                                  '+91',
                                  style: TextStyle(
                                    color: const Color(0xff707070),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),*/
                              //  const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: controller.mobileNumber,
                                    keyboardType: TextInputType.number,

                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(
                                        Icons.mail_outline_outlined,
                                        color: Color(0xff707070),
                                      ),
                                      hintText: 'Enter Email Address',
                                      hintStyle: TextStyle(
                                        fontFamily: 'malgun',
                                        letterSpacing: -0.36.sp,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        */

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
                            : OrganizationProfileButton(
                                onPressed: () {
                                  if (controller.mobileNumber.text.isNotEmpty &&
                                      controller.username.text.isNotEmpty) {
                                    controller.verifyPhone();
                                  } else {
                                    Get.snackbar('Field is Empty',
                                        'Fill all the fields');
                                  }
                                },
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

class OrganizationProfileButton extends StatefulWidget {
  final Function onPressed;

  OrganizationProfileButton({required this.onPressed});

  @override
  _OrganizationProfileButtonState createState() =>
      _OrganizationProfileButtonState();
}

class _OrganizationProfileButtonState extends State<OrganizationProfileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: Transform.scale(
        scale: _animation.value,
        child: Container(
          width: Get.width * 0.5,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.0),
            color: const Color(0xffFFA914),
            border: Border.all(width: 1.0, color: const Color(0xffffffff)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66FFA914),
                offset: Offset(0, 13),
                blurRadius: 34,
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Get OTP'.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 13.sp,
                  color: const Color(0xffffffff),
                  letterSpacing: -0.36,
                  fontWeight: FontWeight.bold,
                  height: 0.9444444444444444,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
