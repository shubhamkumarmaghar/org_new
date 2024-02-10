import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:partypeoplebusiness/controller/party_controller.dart';
import 'package:partypeoplebusiness/views/organization/profile_preview/profile_preview.dart';
import 'package:partypeoplebusiness/views/organization/side_drawer/drawer_view.dart';
import 'package:partypeoplebusiness/views/party/create_party.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../constants/const_strings.dart';
import '../../../controller/organisation/dashboard/organization_dashboard.dart';
import '../../../model/partyModel/partyDataModel.dart';
import '../../../qr_Scanner/view/qr_scanner_view.dart';
import '../../../widgets/location_services.dart';
import '../../notification/notification_screen.dart';
import '../../party/party_container_view.dart';
import '../party_preview/party_preview_screen_new.dart';

class OrganisationDashboard extends StatefulWidget {
  const OrganisationDashboard({Key? key}) : super(key: key);

  @override
  State<OrganisationDashboard> createState() => _OrganisationDashboardState();
}

class _OrganisationDashboardState extends State<OrganisationDashboard> {
  OrganizationDashboardController controller =
      Get.put(OrganizationDashboardController());
  PartyController partyController = Get.put(PartyController());
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  int totalPartiesCount = 0;
  double currentDotIndex = 0.0;
  var partiesJsonData;
  bool itShouldLoad = true;

  readNotificationCount() async {
    http.Response response = await http.post(
        Uri.parse(
            API.readNotification),
        headers: {'x-access-token': '${GetStorage().read('token')}'});

    print('Notification count read ::${response.body}');
  }


  alertBoxWithNavigation() async {
    if (controller.organisationVerification.value == '0') {
      await Alert(
        context: context,
        title: "Under Review",
        desc:
            "Please wait while we are reviewing your application,\n After verification you can start posting parties.",
      ).show();

      // Code will continue after alert is closed.
      debugPrint("Alert closed now.");
    } else {
      Get.to(CreateParty(isPopular: false));
    }
  }

  Future _handleRefresh() async {
    controller.getAPIOverview();
    controller.getOrganisationDetailsPopular();
  }
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showNoInternetDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  bool isDismissed = false;
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        itShouldLoad = false;
      });
    });
    getConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LiquidPullToRefresh(
        key: _refreshIndicatorKey, // key if you want to add
        onRefresh: _handleRefresh, // refresh callback
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 65,
              backgroundColor: Colors.red.shade900,
              leading: GestureDetector(
                onTap: (){
                  Get.to(DrawerView(
                      imageApproval: controller.imageApproval.value.toString(),
                      views: controller.views.value.toString(),
                      likes: controller.likes.value.toString(),
                      profileImageView: controller.circularDP.value.toString(),
                      timeLineImage: controller.timelinePic.value.toString()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/side_drawer.png',
                    color: Colors.white,
                  ),
                ),
              ),

              actions: [
                GestureDetector(
                  onTap: () async {
                   Get.to(QrScanner());
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Icon(CupertinoIcons.qrcode_viewfinder,size: 30,color: Colors.white,)
                   /* Image.asset(
                      'assets/notification.png',
                      fit: BoxFit.fill,
                    )*/,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            await readNotificationCount();
                            Get.to(NotificationScreen());
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                              'assets/notification.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      controller.notificationCount.value.toString() == '0'
                          ? Container()
                          : const Positioned(
                              right: 0,
                              top: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange,
                                maxRadius: 5,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Text(
                          '${controller.organisationName.value}',
                          textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'SegeoUI',
                            color: Colors.white
                          ),
                        ),
                      ),
                      controller.bluetick.value == '1'
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 17,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SmoothStarRating(
                    allowHalfRating: false,
                    starCount: 5,
                    rating: double.parse(controller.organisationRating.value),
                    size: 18.0,
                    color: Colors.orange,
                    borderColor: Colors.orange,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    spacing: .5,
                  ),
                ],
              )),
          drawerEnableOpenDragGesture: false,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xffCE2323),
                  blurRadius: 10,
                ),
              ],
            ),
            child: BottomAppBar(
              height: 50,
              color: const Color(0xff5A0404),
              shape: const CircularNotchedRectangle(),
              elevation: 18,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 30,
                      child: Center(
                          child: Container(
                              height: 26,
                              width: 26,
                              child: Image.asset('assets/home (1).png'))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(ProfilePreviewView(
                            phoneNumber: controller.phoneNumber.value,
                            organizationData: controller.fullOrganizationData,
                          ));
                        },
                        child: Container(
                            height: 26,
                            width: 26,
                            child: Image.asset('assets/profile (1).png'))),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              alertBoxWithNavigation();
            },
            backgroundColor: controller.organisationVerification.value == '1'
                ? const Color(0xffFFA914)
                : Colors.grey[400],
            child: const Icon(
              Icons.add,
              size: 55,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          body: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/red_background.png"),
                          fit: BoxFit.fill))),
              SingleChildScrollView(
                  child: itShouldLoad == false
                      ? Column(
                          children: [
                            controller.organisationVerification.value == '1'
                                ? const SizedBox(
                                    height: 20,
                                  )
                                : Container(),
                            controller.organisationVerification.value == '1'
                                ? Container()
                                : isDismissed == true
                                    ? Container()
                                    : Container(
                                        width: double.infinity,
                                        height: 45,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.warning,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10.0),
                                            Expanded(
                                              child: Text(
                                                "Your account is not verified yet.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    isDismissed = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                      ),
                            controller.organisationVerification.value == '1'
                                ? Container()
                                : const SizedBox(
                                    height: 20,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        height: 58,
                                        child:
                                            Image.asset('assets/22 (2).png')),
                                    Text(
                                      controller.likes.value,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'malgun'),
                                    ),
                                    Text(
                                      'LIKES',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontFamily: 'SegeoUI'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        height: 58,
                                        child:
                                            Image.asset('assets/22 (3).png')),
                                    Text(
                                      controller.views.value,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'malgun'),
                                    ),
                                    Text(
                                      'VIEWS',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontFamily: 'SegeoUI'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        height: 58,
                                        child:
                                            Image.asset('assets/22 (1).png')),
                                    Text(
                                      controller.going.value,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'malgun'),
                                    ),
                                    Text(
                                      'GOING',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontFamily: 'SegeoUI'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'POPULAR EVENTS',
                                style: GoogleFonts.oswald(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                            ),
                            controller.popularPartyLength.value == 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.sp, vertical: 5.sp),
                                    child: Text(
                                      "Sorry, there are no parties available at this time. Please try again later or check back for updates.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount:
                                            controller.popularPartyLength.value,
                                        itemBuilder: (BuildContext context,
                                            int index, int pageViewIndex) {
                                          return GestureDetector(
                                            onTap: () {
                                              /*Get.to(PartyPreview(
                                                isHistory: false,
                                                isPopularParty: true,
                                                data: controller
                                                        .jsonPartyPopularData[index],
                                              ));*/
                                              Get.to(PartyPreviewScreen(
                                                isHistory: false,
                                                isPopularParty: true,
                                                party: controller
                                                    .jsonPartyPopularData[index],
                                              ));
                                            },
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.85,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            18.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              15,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.favorite,
                                                                              size: 15,
                                                                              color: Colors.red.shade900,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          '${controller.jsonPartyPopularData[index].like}',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'LIKE',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              15,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Image.asset('assets/WhatsApp Image 2023-02-23 at 10.55.21 PM.jpeg'),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          '${controller.jsonPartyPopularData[index].view}',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'VIEWS',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              15,
                                                                          child:
                                                                              Center(child: Image.asset('assets/WhatsApp Image 2023-02-23 at 10.55.22 PM.jpeg')),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          '${controller.jsonPartyPopularData[index].ongoing}',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'GOING',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 6.sp),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 30,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: ClipRRect(
                                                                    borderRadius: const BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              12),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              12),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              12),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              12),
                                                                    ),
                                                                    child: controller.jsonPartyPopularData[index].imageStatus == '1'
                                                                        ? Container(
                                                                            height:
                                                                                Get.height * 0.5,
                                                                            width:
                                                                                Get.width * 0.48,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(12),
                                                                                bottomRight: Radius.circular(12),
                                                                                topLeft: Radius.circular(12),
                                                                                topRight: Radius.circular(12),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: '${controller.jsonPartyPopularData[index].coverPhoto}',
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            height:
                                                                                Get.height * 0.5,
                                                                            width:
                                                                                Get.width * 0.48,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(12),
                                                                                bottomRight: Radius.circular(12),
                                                                                topLeft: Radius.circular(12),
                                                                                topRight: Radius.circular(12),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                ImageFiltered(
                                                                              imageFilter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: '${controller.jsonPartyPopularData[index].coverPhoto}',
                                                                              ),
                                                                            ),
                                                                          )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 5,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child:

                                                                  //
                                                                  Stack(
                                                                children: [
                                                                  Container(
                                                                    height: 100,
                                                                    width: 180,
                                                                    child: Card(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15)),
                                                                      elevation:
                                                                          18,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${controller.jsonPartyPopularData[index].title}'.capitalizeFirst!,
                                                                              style: TextStyle(fontSize: 13.sp, overflow: TextOverflow.ellipsis, fontFamily: 'malgun', fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              '${controller.jsonPartyPopularData[index].prStartDate} - ${controller.jsonPartyPopularData[index].prEndDate}',
                                                                              style: TextStyle(fontSize: 9.sp, fontFamily: 'malgun'),
                                                                            ),
                                                                            SmoothStarRating(
                                                                              allowHalfRating: false,
                                                                              starCount: 5,
                                                                              rating: double.parse(controller.organisationRating.value),
                                                                              size: 20.0,
                                                                              color: Colors.orange,
                                                                              borderColor: Colors.orange,
                                                                              filledIconData: Icons.star,
                                                                              halfFilledIconData: Icons.star_half,
                                                                              defaultIconData: Icons.star_border,
                                                                              spacing: .5,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 5,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          partyController
                                                                              .isEditable
                                                                              .value = true;
                                                                          partyController.isRepostParty.value = false;
                                                                          partyController.getPrefiledData =
                                                                              controller.jsonPartyPopularData[index];
                                                                          partyController
                                                                              .isPopular
                                                                              .value = true;
                                                                          Get.to(
                                                                              Get.to(CreateParty(isPopular: true)));
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: EdgeInsets
                                                                                .zero,
                                                                            elevation:
                                                                                0,
                                                                            backgroundColor:
                                                                                Colors.transparent),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            color:
                                                                                Colors.orange,
                                                                          ),
                                                                          child:
                                                                              const Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              color: Colors.white,
                                                                              size: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.38,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.12,
                                                    child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        child: Image.asset(
                                                            'assets/excellence.png'))),
                                              ],
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                          height: 200,
                                          aspectRatio: 16 / 9,
                                          onPageChanged: (i, r) {
                                            setState(() {
                                              controller.count.value = i;
                                            });
                                          },
                                          viewportFraction: 0.96,
                                          enableInfiniteScroll: false,
                                          initialPage: 0,
                                          reverse: false,
                                          autoPlay: false,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,

                                          enlargeFactor: 0.3,
                                          // onPageChanged: callbackFunction,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                      if (controller.popularPartyLength.value !=
                                          0)
                                        DotsIndicator(
                                          dotsCount: controller
                                              .popularPartyLength.value,
                                          position: double.parse(controller
                                              .count.value
                                              .toString()),
                                          decorator: DotsDecorator(
                                            size: const Size.square(9.0),
                                            activeSize: const Size(28.0, 9.0),
                                            activeColor: Colors.orange,
                                            activeShape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                          ),
                                        )
                                    ],
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'TODAY',
                                style: GoogleFonts.oswald(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                            ),
                            PartiesContainerWidget(
                                jsonPartyData:
                                    controller.jsonPartyOrganisationDataToday,
                                lengthOfParties:
                                    controller.lengthOfTodayParties.value),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'TOMORROW',
                                style: GoogleFonts.oswald(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                            ),
                            PartiesContainerWidget(
                                jsonPartyData:
                                    controller.jsonPartyOrganisationDataTomm,
                                lengthOfParties:
                                    controller.lengthOfTommParties.value),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'UPCOMING',
                                style: GoogleFonts.oswald(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                            ),
                            controller.lengthOfUpcomingParties.value == 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.sp, vertical: 5.sp),
                                    child: Text(
                                      "Sorry, there are no parties available at this time. Please try again later or check back for updates.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 190,
                                          width: Get.width,
                                          child: ListView.builder(
                                              controller: ScrollController(
                                                  initialScrollOffset: 0),
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,

                                              // physics: NeverScrollableScrollPhysics(),
                                              itemCount: controller
                                                  .lengthOfUpcomingParties
                                                  .value,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (controller.jsonPartyOgranisationDataUpcomming[
                                                                  index].papularStatus ==
                                                          '1') {
                                                        print(
                                                            "Printing status :: ${controller.jsonPartyOgranisationDataUpcomming[index].papularStatus}");

                                                        Get.to(/*PartyPreview(
                                                          isPopularParty: true,
                                                          isHistory: false,
                                                          data: controller
                                                                  .jsonPartyOgranisationDataUpcomming[
                                                              index],
                                                        ));*/
                                                            PartyPreviewScreen(
                                                          isPopularParty: true,
                                                          isHistory: false,
                                                          party: controller
                                                              .jsonPartyOgranisationDataUpcomming[
                                                          index],
                                                        ));
                                                      } else {
                                                        /*Get.to(PartyPreview(
                                                          isPopularParty: false,
                                                          isHistory: false,
                                                          data: controller
                                                                  .jsonPartyOgranisationDataUpcomming[
                                                              index],
                                                        ));*/
                                                        Get.to(PartyPreviewScreen(
                                                          isPopularParty: false,
                                                          isHistory: false,
                                                          party: controller
                                                              .jsonPartyOgranisationDataUpcomming[
                                                          index],
                                                        ));
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 160,
                                                          width: 171,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xffffffff),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17.0),
                                                          ),
                                                          child: controller.jsonPartyOgranisationDataUpcomming[
                                                                          index].imageStatus ==
                                                                  '1'
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13.0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '${controller.jsonPartyOgranisationDataUpcomming[index].coverPhoto}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13.0),
                                                                  child:
                                                                      ImageFiltered(
                                                                    imageFilter: ui.ImageFilter.blur(
                                                                        sigmaX:
                                                                            8.0,
                                                                        sigmaY:
                                                                            8.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${controller.jsonPartyOgranisationDataUpcomming[index].coverPhoto}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                height: 80,
                                                                width: 171,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          3,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10.0,
                                                                      left:
                                                                          20.0,
                                                                      right:
                                                                          10.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${controller.jsonPartyOgranisationDataUpcomming[index].title}"
                                                                            .capitalizeFirst!,
                                                                        style:
                                                                            TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontFamily:
                                                                              'malgun',
                                                                          fontSize:
                                                                              12.sp,
                                                                          color:
                                                                              const Color(0xff564d4d),
                                                                          height:
                                                                              1.25,
                                                                        ),
                                                                        textHeightBehavior:
                                                                            const TextHeightBehavior(applyHeightToFirstAscent: false),
                                                                        softWrap:
                                                                            false,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat('d, MMM, yyyy').format(DateTime.parse('${controller.jsonPartyOgranisationDataUpcomming[index].startDate}')),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12.sp,
                                                                              color: const Color(0xffc40d0d),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${controller.jsonPartyOgranisationDataUpcomming[index].startTime}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12.sp,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        controller.lengthOfUpcomingParties
                                                                    .value !=
                                                                0
                                                            ? Positioned(
                                                                left: 0,
                                                                top: 0,
                                                                child: Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child: GestureDetector(
                                                                        onTap: () {
                                                                          Get.to(
                                                                              PartyPreviewScreen(
                                                                            isHistory:
                                                                                false,
                                                                            isPopularParty:
                                                                                false,
                                                                            party: controller.jsonPartyOgranisationDataUpcomming[index],
                                                                          ));
                                                                        },
                                                                        child: controller.jsonPartyOgranisationDataUpcomming[index].approvalStatus != "1"
                                                                            ? Card(
                                                                                elevation: 5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                                child: Container(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(40)), child: SizedBox(height: 15, width: 15, child: Lottie.asset('assets/127247-disapproved.json'))),
                                                                              )
                                                                            : controller.jsonPartyOgranisationDataUpcomming[index].papularStatus == '0'
                                                                                ? Card(
                                                                                    elevation: 5,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                                    child: Container(),
                                                                                  )
                                                                                : Container())),
                                                              )
                                                            : Container(),
                                                        Positioned(
                                                          top: 10,
                                                          right: 5,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              partyController
                                                                  .isEditable
                                                                  .value = true;
                                                              partyController.isRepostParty.value = false;
                                                              partyController
                                                                      .getPrefiledData =
                                                                  controller
                                                                          .jsonPartyOgranisationDataUpcomming[
                                                                      index];
                                                              if (controller.jsonPartyOgranisationDataUpcomming[
                                                                          index].papularStatus ==
                                                                  '1') {
                                                                partyController
                                                                    .isPopular
                                                                    .value = true;
                                                                print(
                                                                    "Printing status :: ${controller.jsonPartyOgranisationDataUpcomming[index].papularStatus}");
                                                                Get.to(CreateParty(
                                                                    isPopular:
                                                                        true));
                                                              } else {
                                                                partyController
                                                                        .isPopular
                                                                        .value =
                                                                    false;
                                                                Get.to(CreateParty(
                                                                    isPopular:
                                                                        false));
                                                              }
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 15,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 175.sp),
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  showNoInternetDialogBox() {
    {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.bottomSlide,
          body: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:MainAxisAlignment.center,
            children: [Lottie.asset('assets/noInternet.json',),
              Text('Please check your internet connectivity',textAlign: TextAlign.center,style:TextStyle(fontSize: 18, color: Colors.black) ,)],),
          title: 'No Connection',
          desc: 'Please check your internet connectivity',
          titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
          descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
          btnOkText: "Ok",btnOkColor: Colors.red.shade900,
          btnOkOnPress: () async {
            // Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showNoInternetDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          dismissOnTouchOutside: false
      ).show();
    }
  }


}

