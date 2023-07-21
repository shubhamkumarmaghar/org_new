import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partypeoplebusiness/controller/onboarding_controller/onboarding_controller.dart';

import '../login_user/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static var kHeadingStyle = GoogleFonts.oswald(
    fontSize: 20,
    color: Colors.white,
    letterSpacing: -0.7000000000000001,
    fontWeight: FontWeight.w600,
    height: 1.9964688982282366,
  );

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  OnBoardingController onBoardingController = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! > 10) {
            onBoardingController.decrement();
          } else if (details.primaryVelocity! < -10) {
            onBoardingController.increment();
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, 0.0),
                  radius: 0.424,
                  colors: [
                    Color(0xffb11212),
                    Color(0xff2e0303),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Center(
                child: Obx(() => onBoardingController.pageCount.value == 0
                    ? Image.asset('assets/dancecouple.png')
                    : onBoardingController.pageCount.value == 1
                        ? Image.asset('assets/on2.png')
                        : Image.asset('assets/on3.png')),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => onBoardingController.pageCount.value == 0
                        ? Text('Find Your Partner',
                            style: OnBoardingScreen.kHeadingStyle)
                        : onBoardingController.pageCount.value == 1
                            ? Text('Find Chillout Place',
                                style: OnBoardingScreen.kHeadingStyle)
                            : Text('Find Best Club',
                                style: OnBoardingScreen.kHeadingStyle),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    child: Obx(
                      () => onBoardingController.pageCount.value == 0
                          ? Text(
                              'Discover the ultimate partying experience with PartyMate. Connect with strangers and have an unforgettable time!',
                              style: GoogleFonts.oswald(
                                fontSize: 11,
                                color: Colors.white,
                              ))
                          : onBoardingController.pageCount.value == 1
                              ? Text(
                                  'Join the party with PartyNow! Meet new people and find the hottest parties in town with just a few taps.',
                                  style: GoogleFonts.oswald(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ))
                              : Text(
                                  'Make new friends and party like never before with PartyConnect. Find exciting events and connect with strangers who share your love for partying.',
                                  style: GoogleFonts.oswald(
                                    fontSize: 11,
                                    color: Colors.white,
                                  )),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 45,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  GetStorage().write('onboarding', '1');
                  Get.to(LoginView());
                },
                child: const Text(
                  'Skip\n ',
                  style: TextStyle(
                    fontFamily: 'malgun',
                    fontSize: 11,
                    color: Colors.white,
                    letterSpacing: -0.24,
                    height: 1.6666666666666667,
                  ),
                ),
              ),
            ),
            Obx(
              () => Positioned(
                bottom: 45,
                left: 20,
                child: Row(
                  children: [
                    onBoardingController.pageCount.value == 0
                        ? bottomScrollView(
                            color: const Color(0xffdbb314),
                            width: 33,
                          )
                        : bottomScrollView(
                            color: Colors.white,
                            width: 15,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    onBoardingController.pageCount.value == 1
                        ? bottomScrollView(
                            color: const Color(0xffdbb314),
                            width: 33,
                          )
                        : bottomScrollView(
                            color: Colors.white,
                            width: 15,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    onBoardingController.pageCount.value == 2
                        ? bottomScrollView(
                            color: const Color(0xffdbb314),
                            width: 33,
                          )
                        : bottomScrollView(
                            color: Colors.white,
                            width: 15,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class bottomScrollView extends StatelessWidget {
  bottomScrollView({
    required this.color,
    required this.width,
  });

  final color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(11.0),
      ),
    );
  }
}
