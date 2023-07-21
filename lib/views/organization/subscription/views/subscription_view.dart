// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, must_be_immutable, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:partypeoplebusiness/controller/party_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../controllers/subscription_controller.dart';

// ignore: must_be_immutable
class SubscriptionView extends StatefulWidget {
  String id;
  var data;

  SubscriptionView({required this.id, required this.data});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  PartyController partyController = Get.put(PartyController());
  Razorpay _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      subscriptionController.oderIdPlaced(
        widget.data['id'],
        partyController.popular_start_date.text,
        partyController.popular_end_date.text,
      );
    } catch (e) {
      print('Error in payment success callback: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      // Payment failure logic
      print('Payment error: ${response.message} (${response.code})');
    } catch (e) {
      print('Error in payment error callback: $e');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    try {
      // External wallet logic
      print('External wallet selected: ${response.walletName}');
    } catch (e) {
      print('Error in external wallet callback: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);

    return Scaffold(
        body: SafeArea(
            child: Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.183, -0.74),
          end: Alignment(1.071, -0.079),
          colors: [Color(0xffd10e0e), Color(0xff870606), Color(0xff300202)],
          stops: [0.0, 0.564, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _netflixLogo(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Get Subscriptions',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 18.sp,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: false,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('About Our Pricing'),
                            content: Text(
                                'For 1 Day of Popular Post we charge Rs 499/-'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            height: Get.height * 0.18,
                            width: Get.width * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${partyController.numberOfDays.value}',
                                  style: TextStyle(
                                    fontFamily: 'malgun',
                                    fontSize: 18.sp,
                                    color: Colors.red.shade900,
                                    letterSpacing: -0.88,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  partyController.numberOfDays.value == 1
                                      ? 'DAY'
                                      : 'DAYS',
                                  style: TextStyle(
                                    fontFamily: 'malgun',
                                    fontSize: 16.sp,
                                    color: Colors.red.shade900,
                                    letterSpacing: -0.44,
                                    height: 0.9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '₹${int.parse(partyController.numberOfDays.value.toString()) * 499}',
                                  style: TextStyle(
                                    fontFamily: 'malgun',
                                    fontSize: 18.sp,
                                    color: Colors.red.shade900,
                                    letterSpacing: -0.6,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.title,
                color: Colors.white,
              ),
              title: Text(
                "${widget.data['title']}".capitalizeFirst!,
                style: const TextStyle(
                    fontFamily: 'malgun', fontSize: 17, color: Colors.white),
              ),
              subtitle: Text(
                "${widget.data['description']}".capitalizeFirst!,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_month,
                color: Colors.white,
              ),
              title: Text(
                "Party Start & End Date",
                style: const TextStyle(
                    fontFamily: 'malgun', fontSize: 17, color: Colors.white),
              ),
              subtitle: Text(
                "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['start_date']))} to ${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['end_date']))}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DateTime startDate =
                          DateTime.parse(widget.data['start_date']);
                      DateTime endDate =
                          DateTime.parse(widget.data['end_date']);
                      partyController.getStartDatePop(
                          context, startDate, endDate);
                    },
                    child: TextFieldWithTitleSub(
                      title: 'Popular Start Date',
                      passGesture: () {
                        DateTime startDate =
                            DateTime.parse(widget.data['start_date']);
                        DateTime endDate =
                            DateTime.parse(widget.data['end_date']);
                        partyController.getStartDatePop(
                            context, startDate, endDate);
                      },
                      controller: partyController.popular_start_date,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a start date';
                        } else {
                          return null;
                        }
                      },
                      enabled: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: partyController.popular_start_date.text.isEmpty
                        ? 0.5
                        : 1.0,
                    child: GestureDetector(
                      onTap: () {
                        DateTime startDate =
                            DateTime.parse(widget.data['start_date']);
                        DateTime endDate =
                            DateTime.parse(widget.data['end_date']);
                        if (partyController
                            .popular_start_date.text.isNotEmpty) {
                          partyController.getEndDatePop(
                              context, startDate, endDate);
                        }
                      },
                      child: TextFieldWithTitleSub(
                        title: 'Popular End Date',
                        passGesture: () {
                          DateTime startDate =
                              DateTime.parse(widget.data['start_date']);
                          DateTime endDate =
                              DateTime.parse(widget.data['end_date']);
                          if (partyController
                              .popular_start_date.text.isNotEmpty) {
                            partyController.getEndDatePop(
                                context, startDate, endDate);
                          }
                        },
                        controller: partyController.popular_end_date,
                        enabled:
                            partyController.popular_start_date.text.isNotEmpty,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an end date';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _infoBox(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  var options = {
                    'key': 'rzp_test_qiTDenaoeqV1Zr',
                    // Replace with your Razorpay API key
                    'amount': (int.parse(
                                partyController.numberOfDays.value.toString()) *
                            499) *
                        100,
                    // Amount in paise (e.g., for INR 500.00, use 50000)
                    'name': 'PARTY PEOPLE BUSINESS',
                    'description': 'RAMBER ENTERTAINMENT PVT LTD',
                    'prefill': {
                      'contact': 'CUSTOMER_CONTACT_NUMBER',
                      'email': 'CUSTOMER_EMAIL'
                    },
                    'external': {
                      'wallets': ['paytm'] // Supported wallets
                    }
                  };

                  try {
                    _razorpay.open(options);
                  } catch (e) {
                    print(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  // Set the background color to red
                  onPrimary: Colors.white,
                  // Set the text color to white
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  // Adjust the button padding
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  // Adjust the text font size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Apply rounded corners to the button
                  ),
                ),
                child: Text("Boost Post"),
              ),
            )
          ],
        ),
      ),
    )));
  }

  Widget _netflixLogo() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black54.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 1))
          ]),
      child: Center(child: Image.asset('assets/Logo.png')),
    );
  }

  ///Subscription info box
  Widget _infoBox() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'Your current subscription will end on ${partyController.popular_end_date.text}.\nAnd will not renewed automatically.',
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class FeatureWidget extends StatelessWidget {
  final String title;
  final String description;

  FeatureWidget({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class TextFieldWithTitleSub extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final int? maxlength;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;
  var passGesture;
  final bool enabled; // Added enabled property

  TextFieldWithTitleSub({
    required this.validator,
    this.passGesture,
    this.maxlength,
    required this.title,
    required this.controller,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    required this.enabled, // Passed enabled property
  });

  @override
  State<TextFieldWithTitleSub> createState() => _TextFieldWithTitleSubState();
}

class _TextFieldWithTitleSubState extends State<TextFieldWithTitleSub> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'malgun',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              onTap: widget.passGesture,
              controller: widget.controller,
              maxLength: widget.maxlength,
              keyboardType: widget.inputType,
              obscureText: widget.obscureText,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: InputBorder.none,
                hintText: "Enter ${widget.title}",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onChanged: (value) {
                if (widget.validator != null) {
                  setState(() {
                    _errorMessage = widget.validator!(value);
                  });
                }
              },
              validator: widget.validator,
              // added validator function
              onSaved: (value) {
                widget.controller.text = value!;
              },
              enabled: widget.enabled, // Passed enabled property
            ),
          ),
          if (_errorMessage != null) // display error message if there is one
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
