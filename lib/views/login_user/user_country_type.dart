import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'login_screen.dart';

class SelectUserCountry extends StatefulWidget {
  const SelectUserCountry({super.key});

  @override
  State<SelectUserCountry> createState() => _SelectUserCountryState();
}

class _SelectUserCountryState extends State<SelectUserCountry> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          child:  SafeArea(
              child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height*0.1,),
                      Text('Please Choose Country ',style: TextStyle(fontSize: 25,color: Colors.white),),
                      SizedBox(height: Get.height*0.2,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        GestureDetector(onTap: (){
                          Get.offAll(LoginView());
                        },
                          child: CircleAvatar(backgroundImage: AssetImage('assets/indian_flag.png',) ,radius: 45,
                      ),
                        ),
                        SizedBox(height: Get.width*0.2,),
                        CircleAvatar(backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/other_world.png',) ,radius: 55,
                        ),],),

                    ]),
              ),
              ),
          ),
        )
    );
  }
}
