import 'dart:developer';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:partypeoplebusiness/controller/login_controller/login_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/location_services.dart';
import 'forgot_username.dart';
class LoginView extends StatefulWidget {
  LoginView({Key? key,}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String countryType = '1';

  LoginController controller = Get.put(LoginController());
@override
  void initState() {
  //LocationService.checkPermission(context: context);
    super.initState();
  }

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
                        SizedBox(height: Get.height*0.025,),
                        Text('Please Choose Country ',style: TextStyle(fontSize: 25,color: Colors.white),),
                        SizedBox(height: Get.height*0.025,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                            onTap: (){
                              countryType ='1';
                              log('country type $countryType');
                              setState(() {

                              });
                              //Get.to(LoginView(countryType: '1',));
                            },
                              child:
                              Container(
                                width: Get.width*0.4,
                                  height: Get.width*0.2,
                                //  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child:Card(
                                    shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                      ),
                                  color:  countryType =='1'? Colors.green.shade600:Colors.white,
                                    child: Row( children: [
                                      SizedBox(width: 10),
                                CircleAvatar(backgroundImage: AssetImage('assets/indian_flag.png',) ,radius: 20,
                              ),
                                      SizedBox(width: 10),
                                      Container(width:Get.width*0.15,
                                          child: Text('India',style: TextStyle(fontSize: 20,color: countryType =='1'? Colors.white:Colors.grey.shade900),)),
                              ]
                                    ),
                                  )
                                  ),
                            ),
                            SizedBox(height: Get.width*0.2,),
                            GestureDetector(
                              onTap: (){
                                countryType = '2';

                                setState(() {

                                });
                                log('country type $countryType');
                               // Get.to(LoginView(countryType: '1',));
                              },
                              child:
                              Container(
                                  width: Get.width*0.4,
                                  height: Get.width*0.2,
                                 // margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child:Card(color: countryType =='2'? Colors.green.shade600:Colors.white,
                                    shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                    ),
                                    child: Row( children: [
                                      SizedBox(width: 10),
                                   //   CircleAvatar(backgroundImage: AssetImage('assets/other_world.png',) ,radius: 20,),
                                      Icon(CupertinoIcons.globe,size: 38,color: countryType =='2'? Colors.white:Colors.grey.shade700,),
                                      SizedBox(width: 10),
                                      Container(width:Get.width*0.15,
                                          child:  Text('World ',style: TextStyle(fontSize: 20,color: countryType =='2'? Colors.white:Colors.grey.shade900),)),
                                    ]
                                    ),
                                  )
                              ),
                            ),
                           ],),
                        SizedBox(height: Get.height*0.05,),
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
                        countryType=='1' ?
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
                        ):
                        Align(alignment: Alignment.topLeft,
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
                        countryType=='1' ? Container(
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
                                    maxLength: 10,
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
                        ) :
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
                                  /*  inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],*/
                                    controller: controller.emailAddress,
                                    keyboardType: TextInputType.emailAddress,
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

                       /* Align(
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
                        ),*/
SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            Get.to(ForgotUserName());
                          },
                          child: Container(margin:  const EdgeInsets.only(left: 12.0),
                            alignment:Alignment.centerRight,
                            child: Text('Forgot Username ? ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14
                              ),),),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                side: const BorderSide(color: Colors.white),
                                checkColor: Colors.grey.shade900,
                                activeColor: Colors.white,
                                value: controller.isChecked.value,
                                onChanged: (value) {
                                  setState(() {
                                    controller.isChecked.value =
                                        value ?? false;
                                  });
                                },
                              ),
                              InkWell(
                                  onTap: () async {
                                    const url =
                                        'https://partypeople.in/privacypolicy'; // URL to redirect to
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I agree to the ',
                                          style: TextStyle(
                                            color: Colors.white,

                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                            ],
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
                            : OrganizationProfileButton(
                                onPressed: () {
                                  if (!controller.isChecked.value) {
                                    Get.snackbar('Terms & Condition', 'Please accept the terms and conditions.');
                                  }
                                  else {
                                    if (((controller.mobileNumber.text.isNotEmpty && controller.mobileNumber.text.length ==10) ||
                                        controller.emailAddress.text.isNotEmpty) &&
                                        controller.username.text.isNotEmpty) {
                                      controller.verifyPhone(type: countryType);
                                    } else {
                                      Get.snackbar('Field is Empty',
                                          'Please Fill valid details');
                                    }
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
