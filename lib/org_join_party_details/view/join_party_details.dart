import 'dart:developer';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../views/organization/dashboard/organisation_dashboard.dart';
import '../../widgets/ticketWidget.dart';
import '../controller/single_ticket_details.dart';

class JoinPartyDetails extends StatefulWidget {
   JoinPartyDetails({super.key});

  @override
  State<JoinPartyDetails> createState() => _JoinPartyDetailsState();
}

class _JoinPartyDetailsState extends State<JoinPartyDetails> {
  // DateTime datee=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.red.shade50,
      /*  appBar: AppBar(
          leading: GestureDetector(onTap: (){
            Get.offAll(OrganisationDashboard());
          },child: Icon(Icons.arrow_back)),
        ),*/
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(1, -0.45),
            radius: 0.9,
            colors: [
              Color(0xffb80b0b),
              Color(0xff390202),
            ],
            stops: [0.0, 1],
            transform: GradientXDTransform(
              0.0,
              -1.0,
              1.23,
              0.0,
              -0.115,
              1.0,
              Alignment(0.0, 0.0),
            ),
          ),
        ),
        child: GetBuilder<BookSinglePartyTicketController>(
        init: BookSinglePartyTicketController(),
        builder: (controller) {
          var data = controller.partySingleBookingModel.data?[0];
          return controller.isLoading == false ?
          Column(
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
                GestureDetector(onTap: () {
                  Navigator.pop(context);
                },
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                        child: Icon(Icons.arrow_back, color: Colors.red
                            .shade900,),
                        backgroundColor: Colors.grey.shade200,)),
                ),
                SizedBox(
                  height: Get.width * 0.1,
                ),
                /*  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),),
                    shadowColor: Colors.red.shade800,
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                        Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text('Party Name',maxLines:2,style: TextStyle(fontSize: 25,
                              color: Colors.red.shade300,
                              fontWeight: FontWeight.w700),
                          ),
                                Text('01/10/2031',style: TextStyle(fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700),
                                ),
                          ]
                          ),
                        ),
                        Text('Organization Name',style: TextStyle(fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                        ),
                        Text('Shubham Kumar',style: TextStyle(fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                        ),
                        Text('No of People : 6',style: TextStyle(fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                        ),
                        Text('Party Address : 137/b , c5 , KeshavPuram , Delhi , 311010',maxLines :3, style: TextStyle(fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                        ),
                            SizedBox(height: 20,),
                        Center(
                          child: Image.network('https://cdn.britannica.com/17/155017-050-9AC96FC8/Example-QR-code.jpg',
                            height: Get.height*0.2,
                          width: Get.height*0.2,),
                        ),
                            SizedBox(
                              height: 10,
                            ),
                      ]),
                    ),
                  ),*/
                TicketWidget(pic: '${data?.coverPhoto}',
                  width: Get.width * 0.9,
                  height: Get.height * 0.7,
                  child:
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.width * 0.14,),
                          Container(alignment: Alignment.center,
                            child: Text(
                              '${data?.fullName}', textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(fontSize: 18,
                                  color: Colors.red.shade300,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Blur(blur:5.0 ,
                              child: Image.network(
                                '${data?.qr}',
                                height: Get.height * 0.2,
                                width: Get.height * 0.2,),
                              overlay: partyDateChecker(data?.endDate?? '${DateTime.now()}')==true?Image.network(
                            '${data?.qr}',
                            height: Get.height * 0.2,
                            width: Get.height * 0.2,):Container(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(alignment: Alignment.center,
                            child: Text('${data?.title}', maxLines: 2,
                              style: TextStyle(fontSize: 25,
                                  color: Colors.red.shade300,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          customText(text1:'Venue Name :    ',text2:  '${data?.organizationName}',fontSize: 14 ),
                          customText(text1:'Party Time :     ',text2: '${dateConvert(
                              '${data?.startDate}')}  ${data?.startTime.toString()}',fontSize: 14 ),
                          customText(text1:'Party goes count :   ',text2: '${data?.noOfPeople} ',fontSize: 14 ),
                          customText(text1:'Party Address :     ',text2: '${data?.latitude} ,${data?.longitude} ',fontSize: 14 ,maxLines: 3,),
                          customText(text1:'Coupon code :     ',text2: '${data?.discountDescription}',fontSize: 14 ),
                          customText(text1:'Booked On :       ',text2: '${dateConvert('${data?.createdAt}')} ',fontSize: 14 ),
                          SizedBox(height: 20,),

                        ]),
                  ),
                  isCornerRounded: true,),
                SizedBox(
                  height: Get.width * 0.05,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
               /*   ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ))),onPressed: (){

                  }, child:  Row(
                    children: [
                      Icon(CupertinoIcons.clear_circled),
                      Text('  Reject',style: TextStyle(fontSize: 13.sp),),
                    ],
                  ),),*/
                  ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ))),
                    onPressed: (){
                      if(partyDateChecker(data?.endDate?? '${DateTime.now()}')==true) {
                        controller.approveRejectTicket();
                      }
                      else{
                         Fluttertoast.showToast(msg: 'This QR is Expired Now,');
                      }
                    }, child:
                  Row(
                    children: [
                      Icon(CupertinoIcons.checkmark_alt_circle,),
                      Text(data?.pjApprovalStatus =='0'?'  Approve' :'  Approved',style: TextStyle(fontSize: 13.sp),),
                    ],
                  ),

                  )
                ],)
              ],
            ) : Center(child: CircularProgressIndicator.adaptive());
        }
            ),

      )
    );
  }

  Widget customText({required String text1 ,required String text2 , Color color =Colors.black ,required double fontSize , int maxLines = 1})
  {
return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('$text1  ',style: TextStyle(fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600),
    ),
    SizedBox(width: Get.width*0.45,
      child: Text('$text2',style: TextStyle(fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w600),
      ),
    ),
  ],
);
  }

bool partyDateChecker(String datetime){
  var time = datetime;
  DateTime datee = DateTime.parse(time??'');
  if(DateTime.now().isAfter(datee))
  {
   // Fluttertoast.showToast(msg: 'This QR.is Expired,');
    return false;
  }
  else{
    return true;
  }

}

  String dateConvert(String date){
    String dateTime;
    try{
      log('date time $date');
      if(date.isNotEmpty) {
        DateTime datee = DateTime.parse(date);

        dateTime = DateFormat('dd-MM-yyyy').format(datee);
      }
      else{
        dateTime='NA';
      }
    }
    catch(e){
      print('error $e');
      dateTime='NA';
    }
    return dateTime;
  }
}
