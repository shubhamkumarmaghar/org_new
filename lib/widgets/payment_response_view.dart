import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/party_controller.dart';

import '../views/organization/dashboard/organisation_dashboard.dart';


class PaymentResponseView extends StatefulWidget {
  String orderId;
  String isSuccess;
  String amount;

  PaymentResponseView({
    super.key,
    required this.orderId,
    required this.isSuccess,
    required this.amount
  });

  @override
  State<PaymentResponseView> createState() => _PaymentResponseViewState();
}

PartyController partyController = Get.put(PartyController());

class _PaymentResponseViewState extends State<PaymentResponseView> {
  final _mainHeight = Get.height;
  final _mainWidth = Get.width;
  final individualProfileController = Get.find<PartyController>();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:()async{
      return false;
    } ,
      child: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: SingleChildScrollView(
          child: GetBuilder<PartyController>(
            init: PartyController(),
            builder: (controller) {
              return Container(
                width: _mainWidth,
                height: _mainHeight,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() =>OrganisationDashboard());
                      },
                      child: Container(
                          margin:EdgeInsets.only(left: _mainWidth*0.05,top: _mainWidth*0.1) ,
                          alignment: Alignment.bottomLeft,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.red.shade900,
                            ),
                            backgroundColor: Colors.grey.shade200,
                          )),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.05,
                    ),
                    Card(
                      elevation: 5,
                     shape: RoundedRectangleBorder(
                    side: BorderSide(
                    color: Colors.red.shade900,
                    ),
                borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
              ),
                     margin: EdgeInsets.all(_mainWidth*0.05),
                      child: Column(
                        children: [
                          SizedBox(
                            height: _mainHeight * 0.05,
                          ),
                        Container(
                        height: _mainHeight * 0.2,
                        width: _mainWidth * 0.7,
                        child: Lottie.network(
                            widget.isSuccess == '1'
                                ? 'https://assets-v2.lottiefiles.com/a/20e4a6f2-116f-11ee-b864-bf9e43a0b86d/gjvNK2B3cD.json'
                                : 'https://assets-v2.lottiefiles.com/a/4083ce28-117b-11ee-b045-7790e649eb6a/pP3H8eK2z6.json',
                            width: _mainWidth * 0.05,
                            height: _mainHeight * 0.05),
                      ),
                        SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                        Text(
                          'Subscription Payment ${widget.isSuccess == '1' ? 'Successful' : 'Failed'}',maxLines: 2,
                          style: TextStyle(
                              fontSize: Get.width*0.055,
                              color: Colors.black,
                              fontWeight: FontWeight.w500 ,
                          ),
                        ),
                        Text(
                          'Order ID : ${widget.orderId}',
                          style: TextStyle(
                              fontSize: Get.width*0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: _mainWidth * 0.1,
                          indent: _mainWidth * 0.05,
                          endIndent: _mainWidth * 0.05,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Text(
                          'Amount Paid: ₹${widget.amount}',
                          style: TextStyle(
                              fontSize: Get.width*0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Payed By : EasyBuzz',
                          style: TextStyle(
                              fontSize: Get.width*0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                          SizedBox(
                            height: _mainHeight * 0.05,
                          ),
                      ],
                      ),
                    ),
                    Spacer(),
                     SizedBox(
                      height: _mainHeight * 0.005,
                    ),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                        onPressed: () {
                      Get.offAll(() =>OrganisationDashboard());
                      }, child: Text('Go to HomePage'))
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
