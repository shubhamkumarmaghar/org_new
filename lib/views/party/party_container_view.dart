import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
import '../../controller/party_controller.dart';
import '../../model/partyModel/partyDataModel.dart';
import '../organization/party_preview/party_preview_screen_new.dart';
import 'create_party.dart';

class PartiesContainerWidget extends StatefulWidget {
  int lengthOfParties = 0;
  List<Party> jsonPartyData = [];

  PartiesContainerWidget(
      {required this.lengthOfParties, required this.jsonPartyData});

  @override
  State<PartiesContainerWidget> createState() => _PartiesContainerWidgetState();
}

class _PartiesContainerWidgetState extends State<PartiesContainerWidget> {
  PartyController partyController = Get.find();

  @override
  Widget build(BuildContext context) {
    return widget.lengthOfParties == 0
        ? Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Container(
            height: 190,
            width: Get.width,
            child: ListView.builder(
                controller: ScrollController(initialScrollOffset: 0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,

                // physics: NeverScrollableScrollPhysics(),
                itemCount: widget.lengthOfParties,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.jsonPartyData[index].papularStatus ==
                            '1') {
                          /*Get.to(PartyPreview(
                                  isHistory: false,
                                  isPopularParty: true,
                                  data: widget.jsonPartyData[index],
                                ));*/
                          Get.to(PartyPreviewScreen(
                            isHistory: false,
                            isPopularParty: true,
                            party: widget.jsonPartyData[index],
                          ));
                        } else {
                          /*Get.to(PartyPreview(
                                  isHistory: false,
                                  isPopularParty: false,
                                  data: widget.jsonPartyData[index],
                                ));*/
                          Get.to(PartyPreviewScreen(
                            isHistory: false,
                            isPopularParty: false,
                            party: widget.jsonPartyData[index],
                          ));
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 160,
                            width: 171,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                            child: widget.jsonPartyData[index].imageStatus ==
                                '1'
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(13.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                '${widget.jsonPartyData[index].coverPhoto}',
                                fit: BoxFit.cover,
                              ),
                            )
                                : ClipRRect(
                              borderRadius:
                              BorderRadius.circular(13.0),
                              child: ImageFiltered(
                                imageFilter: ui.ImageFilter.blur(
                                    sigmaX: 8.0, sigmaY: 8.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  '${widget.jsonPartyData[index].coverPhoto}',
                                  fit: BoxFit.cover,
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: const Offset(0,
                                            3), // changes position of shadow
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 20.0,
                                        right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.jsonPartyData[index].title}"
                                              .capitalizeFirst!,
                                          style: TextStyle(
                                            overflow:
                                            TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'malgun',
                                            fontSize: 13.sp,
                                            color:
                                            const Color(0xff564d4d),
                                            height: 1.25,
                                          ),
                                          textHeightBehavior:
                                          const TextHeightBehavior(
                                            applyHeightToFirstAscent:
                                            false,
                                          ),
                                          softWrap: false,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "${widget.jsonPartyData[index].description}"
                                              .capitalizeFirst!,
                                          style: TextStyle(
                                            overflow:
                                            TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'malgun',
                                            fontSize: 12.sp,
                                            color:
                                            const Color(0xff564d4d),
                                            height: 1.25,
                                          ),
                                          textHeightBehavior:
                                          const TextHeightBehavior(
                                            applyHeightToFirstAscent:
                                            false,
                                          ),
                                          softWrap: false,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '${widget.jsonPartyData[index].startTime}',
                                          style: TextStyle(
                                            fontFamily: 'malgun',
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          widget.lengthOfParties != 0
                              ? Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: GestureDetector(
                                  onTap: () {
                                    partyController
                                        .isEditable.value = true;
                                    partyController.isRepostParty.value = false;
                                    partyController
                                        .getPrefiledData =
                                    widget.jsonPartyData[index];
                                    if (widget.jsonPartyData[index].papularStatus ==
                                        '1') {
                                      partyController
                                          .isPopular.value = true;
                                      /*Get.to(PartyPreview(
                                                    isHistory: false,
                                                    isPopularParty: true,
                                                    data: widget
                                                        .jsonPartyData[index],
                                                  ));*/
                                      Get.to(PartyPreviewScreen(
                                        isHistory: false,
                                        isPopularParty: true,
                                        party: widget
                                            .jsonPartyData[index],
                                      ));
                                    } else {
                                      partyController
                                          .isPopular.value = false;
                                      /*   Get.to(PartyPreview(
                                                    isHistory: false,
                                                    isPopularParty: false,
                                                    data: widget
                                                        .jsonPartyData[index],
                                                  ));*/
                                      Get.to(PartyPreviewScreen(
                                        isHistory: false,
                                        isPopularParty: false,
                                        party: widget
                                            .jsonPartyData[index],
                                      ));
                                    }
                                  },
                                  child: widget.jsonPartyData[index].approvalStatus !=
                                      "1"
                                      ? Card(
                                    elevation: 5,
                                    shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            40)),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                            Colors.black,
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                40)),
                                        child: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: Lottie.asset(
                                                'assets/127247-disapproved.json'))),
                                  )
                                      : widget.jsonPartyData[index].papularStatus ==
                                      '1'
                                      ? Container()
                                      : Container()),
                            ),
                          )
                              : Container(),
                          Positioned(
                            top: 10,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                partyController.isEditable.value = true;
                                partyController.isRepostParty.value = false;
                                partyController.getPrefiledData =
                                widget.jsonPartyData[index];
                                partyController.partyId.value = partyController.getPrefiledData.id!;
                                if (widget.jsonPartyData[index].papularStatus ==
                                    '1') {
                                  partyController.isPopular.value = true;
                                  Get.to(Get.to(
                                      CreateParty(isPopular: true)));
                                } else {
                                  partyController.isPopular.value = false;
                                  Get.to(
                                      CreateParty(isPopular: false)
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                         /* Positioned(
                            top: 50,
                            right: 5,
                            child: GestureDetector(
                              onTap: () async{
                                //partyController.isEditable.value = true;
                              //  partyController.isRepostParty.value = false;
                              partyController.getPrefiledData = widget.jsonPartyData[index];
                               // partyController.partyId.value = partyController.getPrefiledData.id!;
                              await   partyController.partystopResume(status: '0',partyId:partyController.getPrefiledData.id! );
                             /*   if (widget.jsonPartyData[index].papularStatus ==
                                    '1') {
                                  partyController.isPopular.value = true;
                                  Get.to(Get.to(
                                      CreateParty(isPopular: true)));
                                } else {
                                  partyController.isPopular.value = false;
                                  Get.to(
                                      CreateParty(isPopular: false)
                                  );
                                }*/
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.stop_circle,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
