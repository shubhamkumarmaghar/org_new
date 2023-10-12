import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeoplebusiness/controller/organisation/create_profile_controller/create_profile_controller.dart';
import 'package:partypeoplebusiness/views/organization/profile/edit_organisation_profile.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../constants/cached_image_placeholder.dart';

class ProfilePreviewView extends StatefulWidget {
  var organizationData;
  String phoneNumber;

  ProfilePreviewView(
      {required this.organizationData, required this.phoneNumber});

  @override
  State<ProfilePreviewView> createState() => _ProfilePreviewViewState();
}

class _ProfilePreviewViewState extends State<ProfilePreviewView> {
  // DashbordController dashbordController = Get.find();
  List<MultiSelectCard> listOfAmenities = [];
  List profileImages =[];
  getAmenities() async {
    setState(() {
      var jsonAddAmenitiesData =
          widget.organizationData['organization_amenities'];
      listOfAmenities.clear();
      for (var i = 0; i < jsonAddAmenitiesData.length; i++) {
        setState(() {
          listOfAmenities.add(MultiSelectCard(
              value: jsonAddAmenitiesData[i]['name'],
              enabled: true,
              perpetualSelected: true,
              highlightColor: Colors.red,
              selected: true,
              label: jsonAddAmenitiesData[i]['name']));
        });
      }
    });
  }


  void getPartyImages()
  {
    if(widget.organizationData['timeline_pic']!=null){
      profileImages.add(widget.organizationData['timeline_pic']);
    }
    if(widget.organizationData['profile_pic_b']!=null){
      profileImages.add(widget.organizationData['profile_pic_b']);
    }
    if(widget.organizationData['profile_pic_c']!=null){
      profileImages.add(widget.organizationData['profile_pic_c']);
    }
    if(widget.organizationData['profile_pic_d']!=null){
      profileImages.add(widget.organizationData['profile_pic_d']);
    }
    if(widget.organizationData['profile_pic_e']!=null){
      profileImages.add(widget.organizationData['profile_pic_e']);
    }
    if(widget.organizationData['profile_pic']!=null){
      profileImages.add(widget.organizationData['profile_pic']);
    }
    profileImages.forEach((element) {
      print(element.toString());
    });
  }


  @override
  void initState() {
    getAmenities();
    getPartyImages();
    super.initState();
  }

  CreteOrganisationProfileController addOrganizationsEventController =
      Get.put(CreteOrganisationProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(

          children: [
            Stack(
              children: [
              /*  Container(
                  child: CachedNetworkImageWidget(
                    imageUrl: '${widget.organizationData['timeline_pic']}',
                    fit: BoxFit.fill,
                    height: Get.height*0.35,
                    width: Get.width,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error_outline),
                    placeholder: (context, url) => const Center(
                        child: CupertinoActivityIndicator(
                            color: Colors.white, radius: 15)),
                  ),
                ),*/
                if (widget.organizationData['profile_pic_approval_status'] == '1')
                  Card(elevation: 5,
                    //color: Colors.orange,
                    clipBehavior:Clip.hardEdge ,
                    margin: EdgeInsets.only(bottom: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),),
                    child:
                    CarouselSlider(items: profileImages.map((element) =>
                        customImageSlider(partyPhotos: element, imageStatus: '${widget.organizationData['profile_pic_approval_status']}') ).toList(),
                      options: CarouselOptions(
                        height: Get.height*0.4,
                        // enlargeCenterPage: true,
                        autoPlay: true,
                        //aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 1
                      ),
                    ),

                  ),
                Positioned(
                  bottom: Get.width * 0.08,
                  left: Get.width * 0.03,
                  //left: Get.width * 0.4,
                  child: ClipOval(
                    child: Stack(
                      children: [
                        CachedNetworkImageWidget(
                          imageUrl: '${widget.organizationData['profile_pic']}',
                          fit: BoxFit.fill,
                          height: 100,
                          width: 100,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error_outline),
                          placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                                  color: Colors.black, radius: 15)),
                        ),
                        if (widget.organizationData[
                                'profile_pic_approval_status'] ==
                            '0')
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.organizationData['profile_pic_approval_status'] !=
                    '1')
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                //  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      customIconText(icon: CupertinoIcons.person_alt_circle, text: "${widget.organizationData['name']}"),
                    OrganizationProfileButton(
                    onPressed: () {
                      addOrganizationsEventController.isProfileEditable.value =true;
                      Get.to(const EditOrganisationProfile());
                    },
                  ),
                  ],),
                    const SizedBox(
                      height: 10,
                    ),
                    customIconText(icon: CupertinoIcons.person, text: "Username: ${GetStorage().read('username')}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width * 0.8,
                      child: Text(
                        "${widget.organizationData['description']}"
                            .capitalizeFirst!,
                        //textAlign: TextAlign.center,
                        maxLines: 4,
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.2,
                            fontSize: 14.sp,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      rating: double.parse(widget.organizationData['rating']),
                      size: 18.sp,
                      color: Colors.orange,
                      borderColor: Colors.orange,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      spacing: .5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    customIconText(icon: CupertinoIcons.phone_circle, text: widget.phoneNumber,),
                    const SizedBox(
                      height: 10,
                    ),
                    customIconText(icon: CupertinoIcons.list_dash , text: widget.organizationData['branch'],),
                    const SizedBox(
                      height: 10,
                    ),
                    LikesAndViewsWidget(
                        likes: int.parse(widget.organizationData['like']),
                        views: int.parse(widget.organizationData['view'])),
                    const SizedBox(
                      height: 10,
                    ),
                    customIconText(icon: CupertinoIcons.location ,
                      text:  widget.organizationData['city_id'] == '-'
                        ? ''
                        : "${widget.organizationData['city_id']}",
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Selected Amenities",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MultiSelectContainer(
                      isMaxSelectableWithPerpetualSelects: true,
                      controller: MultiSelectController(
                          deSelectPerpetualSelectedItems: true),
                      itemsDecoration: const MultiSelectDecorations(),
                      itemsPadding: const EdgeInsets.all(10),
                      highlightColor: Colors.red,
                      maxSelectableCount: 0,
                      prefix: MultiSelectPrefix(
                          disabledPrefix: const Icon(
                        Icons.do_disturb_alt_sharp,
                        color: Colors.red,
                        size: 14,
                      )),
                      items: listOfAmenities,
                      onChange: (List<dynamic> selectedItems, selectedItem) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
  Widget customImageSlider({
    required String partyPhotos, required String imageStatus
  }
      ){
    return
      Container(
        height: Get.height*0.4,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.cover),
        ),
        width: Get.width,
        /* child: Image.network(
                        widget.party.coverPhoto,
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                      ), */
      );
  }
}

Widget customIconText({required IconData icon , required String text}){
  return Row(children: [
    Icon(icon,color: Colors.grey,),
    SizedBox(width: 5,),
    Text(
    text
        .capitalizeFirst!,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      // letterSpacing: 1.01,
      fontSize: 13.sp,
      fontWeight: FontWeight.normal,
    ),
  ),
  ],);
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
          width: Get.width*0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffFF4D4D),
                Color(0xffFF0000),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
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

class TitleAnswerWidget extends StatelessWidget {
  final String title;
  final String answer;

  TitleAnswerWidget({required this.title, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.2),
            ),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class LikesAndViewsWidget extends StatelessWidget {
  final int likes;
  final int views;

  LikesAndViewsWidget({required this.likes, required this.views});

  String _convertToKMB(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 4,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(
                Icons.favorite,
                size: 28.0,
                color: Colors.red.shade900,
              ),
              const SizedBox(height: 8.0),
              Text(
                _convertToKMB(likes),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          Container(
            height: 40.0,
            width: 1.0,
            color: Colors.grey[350],
          ),
          Column(
            children: [
              Icon(
                Icons.people,
                size: 28.0,
                color: Colors.red.shade900,
              ),
              const SizedBox(height: 8.0),
              Text(
                _convertToKMB(views),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
