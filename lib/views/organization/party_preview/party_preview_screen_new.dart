import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:sizer/sizer.dart';

import '../../../constants/const_strings.dart';
import '../../../controller/party_controller.dart';
import '../../../model/partyModel/partyDataModel.dart';
import '../../../org_book_party_report/view/book_party_list_screen.dart';
import '../../party/party_amenities.dart';
import '../subscription/views/subscription_view.dart';

class Amenities {
  final String id;
  final String name;

  Amenities({required this.id, required this.name});
}

class PartyPreviewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Party party;
  bool isPopularParty;
  bool isHistory;
  PartyPreviewScreen({super.key, required this.party,
    required this.isPopularParty,
    required this.isHistory});

  @override
  State<PartyPreviewScreen> createState() => _PartyPreviewScreenState();
}

class _PartyPreviewScreenState extends State<PartyPreviewScreen> {
  double _currentSliderValue = 0;
  String join = 'Join';
  List<Category> _categories = [];
  final List partyImages =[];
  final List<CategoryList> _categoryLists = [];
  List selectedAmenities = [];
  PartyController controller = Get.find();
  
  void getpartyImages()
  {
    if(widget.party.coverPhoto!=null){
      partyImages.add(widget.party.coverPhoto);
    }
    if(widget.party.imageB!=null){
      partyImages.add(widget.party.imageB);
    }
    if(widget.party.imageC!=null){
      partyImages.add(widget.party.imageC);
    }
    partyImages.forEach((element) {
      print(element.toString());
    });
  }

  Future<bool> changeSeatAvailable({ required String value ,required String partyID}) async {
    http.Response response = await http.post(
      Uri.parse(API.partySeatAvailable),
      body: {'seat_occupancy':value.toString(),
        'party_id':partyID},
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    var data = jsonDecode(response.body);
    print('data ${response.body} ');

      if (data['status'] == 1) {
Fluttertoast.showToast(msg: data['message']);
return true;
      }
      else{
        Fluttertoast.showToast(msg: 'Failed to update Party seat occupancy .');
        return false;
      }
    setState(() {
    });
  }

  Future<void> _fetchData() async {
    http.Response response = await http.get(
      Uri.parse(API.partyAmenities),
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    final data = jsonDecode(response.body);
    setState(() {
      if (data['status'] == 1) {
        _categories = (data['data'] as List)
            .map((category) => Category.fromJson(category))
            .toList();

        _categories.forEach((category) {
          _categoryLists.add(CategoryList(
              title: category.name, amenities: category.amenities));

        });
        getSelectedID();
      }
    });
  }
  void getSelectedID() {
    int? len = widget.party.partyAmenitie?.length;
    for (var i = 0; i < len!; i++) {
      var amenityName = widget.party.partyAmenitie?[i].name;
      print(amenityName);
      setState(() {
        _categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.name == amenityName) {
              if (controller.selectedAmenities.contains(amenity.id)) {
              } else {
                controller.selectedAmenities.add(amenity.id);
              }
              amenity.selected = true;
            }
          });
        });
      });
    }
  }

  @override
  void initState() {
    controller.partyId.value = widget.party.id!;
    _currentSliderValue = double.parse('${widget.party.seat_occupancy}');
    _fetchData();
    getpartyImages();
    print(" ${widget.party.toJson()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: (){Navigator.pop(context);},
                      child: Container(alignment: Alignment.bottomLeft,
                          child: CircleAvatar(child: Icon(Icons.arrow_back,color: Colors.red.shade900,),
                            backgroundColor: Colors.grey.shade200,)),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Get.to(BookPartyListView(),arguments: widget.party.organizationId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      ),
                      child: Text(
                        'Booking List',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize:14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(children: [
                  if (widget.party.imageStatus == '1')
                    Card(elevation: 5,
                    clipBehavior:Clip.hardEdge ,
                    margin: EdgeInsets.only(bottom: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),),
                    child:
                    CarouselSlider(items: partyImages.map((element) =>
                        customImageSlider(partyPhotos: element, imageStatus: '${widget.party.imageStatus}') ).toList(),
                      options: CarouselOptions(
                        height: Get.height * 0.295,
                        // enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 1,
                        //aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                      ),),
                    
                ) 
                  else Card(elevation: 5,
                      margin: EdgeInsets.only(bottom: 25),
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15.0),),
                  child:  CarouselSlider(
                    items: partyImages.map((element) =>
                      customImageSlider(partyPhotos: element, imageStatus: '${widget.party.imageStatus}') ).toList(),
                    options: CarouselOptions(
                      height: Get.height * 0.295,
                      // enlargeCenterPage: true,
                      autoPlay: true,
                      //aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1

                    ),),
                    ),
                ],),

                if (widget.isPopularParty == false)
                  const SizedBox(
                    height: 15,
                  ),
                widget.isHistory == true
                    ? Container()
                    : widget.isPopularParty == false
                    ? BoostButton(
                    color: widget.party.approvalStatus != '1'
                        ? Colors.grey.shade300
                        : Colors.purple.shade900,
                    label: 'Boost Post',
                    onPressed: () async {
                      if (widget.party.approvalStatus != '1') {
                      } else {
                        await controller.getSubscriptionPlan();
                        Get.to(SubscriptionView(
                            id: '${widget.party.id}', data: widget.party));
                      }
                    })
                    : Container(),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomTextIcon(icon: CupertinoIcons.heart, IconText: "${widget.party.like} Likes"),
                     CustomTextIcon(icon: CupertinoIcons.eye, IconText: "${widget.party.view} Views"),

                      CustomTextIcon(icon: CupertinoIcons.person_3, IconText: "${widget.party.ongoing} Going"),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Available Seat',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'malgun',
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  divisions: 10,
                  activeColor: Colors.red.shade900,
                  inactiveColor: Colors.red.shade50,
                  label: _currentSliderValue.round().toString(),
                  onChangeEnd: (double value)async{
                    if(_currentSliderValue != widget.party.seat_occupancy) {
                      await changeSeatAvailable(value: _currentSliderValue.toString(),
                      partyID: '${widget.party.id}');
                    }
                  },
                  onChanged: (double value) async{
                    _currentSliderValue = value;

                      setState(() {


                      });

                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  '${widget.party.title?.capitalizeFirst}',
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'malgun',
                      fontSize: 28,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${widget.party.description?.capitalizeFirst}',
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'malgun',
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),
                const Divider(),

               /* widget.party.papularStatus == '1'
                    ? CustomListTile(
                  icon: Icons.calendar_month_outlined,
                  title: "Popular Party Dates",
                  subtitle:
                  "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.party.prStartDate))} to ${widget.party.endDate != null ? DateFormat('EEEE, d MMMM y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.party.endDate) * 1000)) : ''}",
                  sub: true,
                )
                    : Container(),
                */
               widget.party.papularStatus == '1'
                    ? CustomListTile(
                  icon: Icons.calendar_month_outlined,
                  title: "Popular Party Dates",
                  subtitle:
                  "${DateFormat('EEEE, d MMMM y').format(DateTime.parse('${widget.party.prStartDate}'))}",
                  sub: true,)
                    :Container(),

                CustomListTile(
                  icon: Icons.calendar_month,
                  title: "${DateFormat('EEEE, d MMMM y').format(DateTime.parse('${widget.party.startDate}'))} to ${DateFormat('EEEE, d MMMM y').format(DateTime.parse('${widget.party.endDate}'))}",
                  subtitle:
                  "${widget.party.startTime}  to  ${widget.party.endTime }",
                  sub: true,
                ),

                CustomListTile(
                  icon: Icons.location_on,
                  title: "Address ",
                  subtitle: "${widget.party.address} ",
                  sub: true,
                ),

                /*   CustomListTile(
                icon: Icons.favorite,
                title: "${widget.party.like} Likes",
                subtitle: "${widget.party.like} Likes",
                sub: false,
              ),

              CustomListTile(
                icon: Icons.remove_red_eye_sharp,
                title: "${widget.party.view} Views",
                subtitle: "${widget.party.view} Views",
                sub: false,
              ),
              CustomListTile(
                icon: Icons.group_add,
                title: "${widget.party.ongoing} Goings",
                subtitle: "${widget.party.ongoing} Goings",
                sub: false,
              ),

              */
                CustomListTile(
                  icon: Icons.supervised_user_circle_outlined,
                  title: '${widget.party.gender
                      ?.replaceAll('[', '')
                      .replaceAll(']', '')}'
                      ,
                  subtitle:'${widget.party.gender
                      ?.replaceAll('[', '')
                      .replaceAll(']', '')}',
                  sub: false,
                ),
                GestureDetector(
                  onTap: (){
                    UrlLauncher.launch("tel://${widget.party.phoneNumber}");
                  },
                  child: CustomListTile(
                    icon: Icons.phone,
                    title: "Call Us",
                    subtitle: '${widget.party.phoneNumber}',
                    sub: true,
                  ),
                ),
                CustomListTile(
                  icon: Icons.group,
                  title: "${widget.party.startAge} to ${widget.party.endAge}  age",
                  subtitle: "${widget.party.startAge} - ${widget.party.endAge} ",
                  sub: false,
                ),
                CustomListTile(
                  icon: Icons.warning,
                  title: "Maximum Guests",
                  subtitle: '${widget.party.personLimit}',
                  sub: true,
                ),
               CustomListTile(
                  icon: Icons.local_offer,
                  title: "Offers",
                  subtitle: '${widget.party.offers}',
                  sub: true,
                ),
                CustomListTile(
                  icon: Icons.local_offer,
                  title: widget.party.discountType == '1' ?"Percent Wise Discount ":widget.party.discountType == '2' ?"Flat Discount":"No Discount ",
                  subtitle: '${widget.party.discountType == '2' ?"Discount Amount : ₹":"Discount Percent : "}${widget.party.discountAmount??"NA"} ${widget.party.discountType == '1' ?"%":""} \n'
                      'Max Discount: ₹${widget.party.billMaxAmount??"NA"} \n'
                  'Discount Description : ${widget.party.discountDescription??"NA"}',
                  sub: true,
                ),


                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    // color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      /*  BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),*/
                    ],
                  ),
                  //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200.withOpacity(0.5)
                        ),
                        child: Icon(
                          Icons.currency_rupee,
                          color:  Colors.red.shade900,
                        ),
                      ),
                      SizedBox(width: Get.width*0.05,),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const Text(
                          'Entry Fees',
                          style: TextStyle(
                              fontFamily: 'malgun',
                              fontSize: 17,
                              color: Colors.black,fontWeight: FontWeight.w600),
                        ),  Container(
                          padding: const EdgeInsets.only(top: 4, bottom: 5),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Ladies',
                                    style: TextStyle(
                                        fontFamily: 'malgun',
                                        fontSize: 15,
                                        color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Couples',
                                    style: TextStyle(
                                        fontFamily: 'malgun',
                                        fontSize: 15,
                                        color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Stag',
                                    style: TextStyle(
                                        fontFamily: 'malgun',
                                        fontSize: 15,
                                        color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Others',
                                    style: TextStyle(
                                        fontFamily: 'malgun',
                                        fontSize: 15,
                                        color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.party.ladies == '0'
                                      ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  )
                                      : Text(
                                    "  - ₹ ${widget.party.ladies}",
                                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  widget.party.couples == '0'
                                      ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  )
                                      : Text(
                                    "  - ₹ ${widget.party.couples}",
                                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  widget.party.stag == '0'
                                      ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  )
                                      : Text(
                                    "  - ₹ ${widget.party.stag}",
                                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  widget.party.others == '0'
                                      ? const Text("  - NA",
                                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600))
                                      : Text(
                                    "  - ₹ ${widget.party.others}",
                                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ]
                        ,)
                    ],
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Selected Amenities",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'malgun', fontSize: 18),
                    ),
                  ),
                ),
                 Visibility(
                  visible: _categoryLists.isNotEmpty,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _categoryLists.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final categoryList = _categoryLists[index];
                      return categoryList.amenities.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (categoryList.amenities.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                categoryList.title.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 5.0,
                              children: categoryList.amenities.map((amenity) {
                                return GestureDetector(
                                  onTap: () {},
                                  child:
                                  amenity.selected
                                      ? Chip(
                                    label: Text(
                                      amenity.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontFamily: 'malgun',
                                      ),
                                    ),
                                    backgroundColor: amenity.selected
                                        ? Colors.red.shade900
                                        : Colors.grey[400],
                                  )
                                      : Container(),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      )
                          : Container();
                    },
                  ),
                ),



              ],
            ),
          ),
      );

  }
  
  Widget CustomTextIcon({required IconData icon , required String IconText})
  {
    return Container(

      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color:  Colors.red.shade900,
            borderRadius: BorderRadius.circular(100.sp),
            
          ),padding: EdgeInsets.all(8),
          child: Icon(icon,
            color:  Colors.white,
            size: 24,),
        ),
        SizedBox(height:Get.height*0.003 ,),
        Text(IconText,style: TextStyle(
          fontFamily: 'malgun',
          fontSize: 14,
          color: Colors.black,
        ),)
      ]),
    );
  }
  
  Widget customImageSlider({
    required String partyPhotos, required String imageStatus
}
      ){
    return
       Container(
          height: Get.height*0.295,
          decoration: BoxDecoration(
           // borderRadius: BorderRadius.circular(15),
            image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.fill),
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

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool sub;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.sub,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
       // color: Colors.red.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
        /*  BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),*/
        ],
      ),
    //  padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200
          ),
          child: Icon(
            icon,
            color:  Colors.red.shade900,
            size: 22,
          ),
        ),
        SizedBox(width: Get.width*0.05,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            FittedBox(
              child: Container(width: Get.width*0.7,
                child: Text(
          title.capitalizeFirst!,
          style: const TextStyle(
                fontFamily: 'malgun',
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
          ),
        ),
              ),
            ),
          sub == true? FittedBox(
            child: Container(
              width: Get.width*0.7,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ):Container(),],)
        ],

      ),
    );
  }
}

class TitleAnswerWidget extends StatelessWidget {
  final String title;
  final String answer;

  const TitleAnswerWidget(
      {super.key, required this.title, required this.answer});

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
              fontSize: 18,
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
                fontSize: 18,
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

class BoostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final color;

  const BoostButton(
      {Key? key,
        required this.color,
        required this.label,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

  }
  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
