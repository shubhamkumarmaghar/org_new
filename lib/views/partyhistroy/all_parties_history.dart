import 'dart:convert';
import 'dart:developer';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeoplebusiness/controller/organisation/dashboard/organization_dashboard.dart';
import 'package:partypeoplebusiness/views/partyhistroy/party_history_controller/party_History_controller.dart';
import 'package:sizer/sizer.dart';

import '../../model/partyModel/partyDataModel.dart';
import '../../widgets/payment_response_view.dart';
import '../organization/party_preview/party_preview_screen_new.dart';
import '../party/create_party.dart';

class AllPartiesHistory extends StatefulWidget {
  const AllPartiesHistory({Key? key}) : super(key: key);

  @override
  State<AllPartiesHistory> createState() => _AllPartiesHistoryState();
}

class _AllPartiesHistoryState extends State<AllPartiesHistory> {
  var data;
  //List<Party> allParties = [];
  OrganizationDashboardController dashboardController = Get.find();

 /* getAllPartiesHistory() async {

      dashboardController.isLoading.value = true;


    try {
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_user_organization_party_by_id'),
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        },
        body: {
          'organization_id': '${dashboardController.organisationID.value}',
          'status': '0',
        },
      );
      log('abcd ${jsonDecode(response.body)}');
      var decodedData = jsonDecode(response.body);
      print(decodedData);
      if (decodedData != null) {
        setState(() {
          //status = '1';
        });
      }
      setState(() {
        allParties = decodedData['data'];

        allParties.sort((a, b) {
          DateTime startDateA = DateTime.parse('${a.startDate}');
          DateTime startDateB = DateTime.parse('${b.startDate}');
          return startDateA.compareTo(startDateB);
        });
        allParties = allParties.reversed.toList(); // Reversing the list

        dashboardController.isLoading.value = false;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        //status = '0';
        dashboardController.isLoading.value = false;
      });
    }
  }
*/

  @override
  void initState() {
 //   getAllPartiesHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
      GetBuilder<PartyHistoryController>(
        init: PartyHistoryController(),
        builder:(controller) {
          return controller.isLoading == true
              ? const Center(
              child: CupertinoActivityIndicator(
                radius: 15,
                color: Colors.black,
              ))
              :  Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(1, -0.45),
                    radius: 0.9,
                    colors: [
                      Color(0xff7e160a),
                      Color(0xff2e0303),
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
              ),
              ListView.builder(
                itemCount: controller.allParties.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      /*Get.to(PartyPreview(
                              data: allParties[index],
                              isPopularParty: false,
                              isHistory: true,
                            ));*/
                      Get.to(PartyPreviewScreen(
                        party: controller.allParties[index],
                        isPopularParty: false,
                        isHistory: true,
                      ));
                    },
                    child: CustomListTile(
                      party: controller.allParties[index],
                      endTime: '${controller.allParties[index].endTime}',
                      startTime: '${controller.allParties[index].startTime}',
                      endDate: '${controller.allParties[index].endDate}',
                      startDate: '${controller.allParties[index].startDate}',
                      title: '${controller.allParties[index].title}',
                      subtitle: '${controller.allParties[index].description}',
                      trailingText: "Trailing Text",
                      leadingImage: '${controller.allParties[index].coverPhoto}',
                      leadingIcon: const Icon(Icons.history),
                      trailingIcon: const Icon(Icons.add),
                      city: '${controller.allParties[index].city}',
                    ),
                  );
                },
              ),
            ],
          );
        },
      )
    );
  }
}

class CustomListTile extends StatelessWidget {
  final Party party;
  final String title;
  final String subtitle;
  final String leadingImage;
  final String trailingText;
  final String startTime; // new field for start time
  final String endTime; // new field for end time
  final Widget leadingIcon;
  final String startDate;
  final String endDate;
  final Widget trailingIcon;
  final String city;

  CustomListTile({
    required this.party,
    required this.title,
    required this.startTime, // pass start time to constructor
    required this.endTime, // pass end time to constructor

    required this.subtitle,
    required this.leadingImage,
    required this.startDate,
    required this.endDate,
    required this.trailingText,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.08,
          right: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.07),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3c0103),
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(255, 110, 19, 9),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                    vertical: MediaQuery.of(context).size.height * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.length > 1
                          ? title[0].toUpperCase() + title.substring(1)
                          : title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFd3b2b1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0.sp,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: const Color(0xFFd3b2b1),
                          size: 13.sp,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.015,
                        ),
                        Text(
                          "${startDate} $startTime\n${endDate} $endTime",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Stack(children: [Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.13,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image(
                  image: CachedNetworkImageProvider(leadingImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
       Positioned(bottom: 0,child: GestureDetector(onTap: (){
    partyController.isEditable.value = true;
    partyController.getPrefiledData = party;
    partyController.isPopular.value = false;
    partyController.isRepostParty.value = true;
    Get.to(
    CreateParty(isPopular: false)
    );
    },
    child: Container(
                  alignment: Alignment.center,
                  height: Get.width*.07,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(color: Colors.red.shade200,
                    borderRadius:BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      ),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.refresh),
                      Text('Repost',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600)),
                    ],
                  ),),
       ) ),
            ],
            ),
          ],
        ),
      ),
    );
  }
}
