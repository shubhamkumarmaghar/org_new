import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:partypeoplebusiness/constants/cached_image_placeholder.dart';
import 'package:partypeoplebusiness/controller/party_controller.dart';
import 'package:sizer/sizer.dart';

import '../../party/party_amenities.dart';
import '../subscription/views/subscription_view.dart';

class Amenity {
  final String id;
  final String name;

  Amenity({required this.id, required this.name});
}

class PartyPreview extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;

  bool isPopularParty;
  bool isHistory;

  PartyPreview(
      {required this.data,
      required this.isPopularParty,
      required this.isHistory});

  @override
  State<PartyPreview> createState() => _PartyPreviewState();
}

class _PartyPreviewState extends State<PartyPreview> {
  List<Category> _categories = [];
  List<CategoryList> _categoryLists = [];

  Future<void> _fetchData() async {
    http.Response response = await http.get(
      Uri.parse('http://app.partypeople.in/v1/party/party_amenities'),
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

  PartyController controller = Get.put(PartyController());

  void getSelectedID() {
    for (var i = 0; i < widget.data['party_amenitie'].length; i++) {
      var amenityName = widget.data['party_amenitie'][i]['name'];
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
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 65,
            ),
            widget.data['image_status'] == '1'
                ? Container(
                    padding: EdgeInsets.zero,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: Get.width,
                    child: CachedNetworkImageWidget(
                        imageUrl: '${widget.data['cover_photo']}',
                        width: Get.width,
                        height: 160,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Center(
                              child: CupertinoActivityIndicator(
                                radius: 15,
                                color: Colors.black,
                              ),
                            ),
                        placeholder: (context, url) => const Center(
                            child: CupertinoActivityIndicator(
                                color: Colors.black, radius: 15))),
                  )
                : Container(
                    padding: EdgeInsets.zero,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: Get.width,
                    child: ImageFiltered(
                      imageFilter:
                          ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: CachedNetworkImageWidget(
                          imageUrl: '${widget.data['cover_photo']}',
                          width: Get.width,
                          height: 160,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) => const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 15,
                                  color: Colors.black,
                                ),
                              ),
                          placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                                  color: Colors.black, radius: 15))),
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "${widget.data['title']}".capitalizeFirst!,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'malgun',
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "${widget.data['description']}".capitalizeFirst!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 12.sp,
                  color: const Color(0xff7D7373),
                ),
              ),
            ),
            if (widget.isPopularParty == false)
              const SizedBox(
                height: 15,
              ),
            widget.isHistory == true
                ? Container()
                : widget.isPopularParty == false
                    ? BoostButton(
                        color: widget.data['approval_status'] != '1'
                            ? Colors.grey.shade300
                            : Colors.purple.shade900,
                        label: 'Boost Post',
                        onPressed: () {
                          if (widget.data['approval_status'] != '1') {
                          } else {
                            Get.to(SubscriptionView(
                                id: widget.data['id'], data: widget.data));
                          }
                        })
                    : Container(),
            const Divider(),
            widget.data['pr_start_date'] != null
                ? CustomListTile(
                    icon: Icons.calendar_month,
                    title: "Popular Party Dates",
                    subtitle:
                        "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['pr_start_date']))} to ${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['pr_end_date']))}",
                  )
                : Container(),
            CustomListTile(
              icon: Icons.calendar_month,
              title: "Party Start & End Dates",
              subtitle:
                  "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['start_date']))} to ${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.data['end_date']))}",
            ),
            CustomListTile(
              icon: Icons.favorite,
              title: "Party Likes",
              subtitle: "${widget.data['like']} Likes",
            ),
            CustomListTile(
              icon: Icons.remove_red_eye_sharp,
              title: "Party Views",
              subtitle: "${widget.data['view']} Views",
            ),
            CustomListTile(
              icon: Icons.group_add,
              title: "Party Goings",
              subtitle: "${widget.data['ongoing']} Goings",
            ),
            CustomListTile(
              icon: Icons.supervised_user_circle_outlined,
              title: "Gender Allowed",
              subtitle: "${widget.data['gender']}"
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .capitalizeFirst!,
            ),
            CustomListTile(
              icon: Icons.phone,
              title: "Party Contact Number",
              subtitle: "${widget.data['phone_number']}",
            ),
            CustomListTile(
              icon: Icons.group,
              title: "Age Allowed Between",
              subtitle:
                  "${widget.data['start_age']} - ${widget.data['end_age']} ",
            ),
            CustomListTile(
              icon: Icons.warning,
              title: "Persons Limit",
              subtitle: "${widget.data['person_limit']}",
            ),
            CustomListTile(
              icon: Icons.local_offer,
              title: "Offers",
              subtitle: "${widget.data['offers']}",
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Entry Fees',
                    style: TextStyle(
                        fontFamily: 'malgun',
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 5),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Ladies',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Couples',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Stag',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Others',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.data['ladies'] == '0'
                                ? Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.data['ladies']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            widget.data['couples'] == '0'
                                ? Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.data['couples']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            widget.data['stag'] == '0'
                                ? Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.data['stag']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            widget.data['others'] == '0'
                                ? Text("  - NA",
                                    style: TextStyle(color: Colors.white))
                                : Text(
                                    "  - ₹ ${widget.data['others']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                      color: Colors.black, fontFamily: 'malgun', fontSize: 16),
                ),
              ),
            ),
            Visibility(
              visible: _categoryLists.isNotEmpty,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _categoryLists.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
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
                              padding: const EdgeInsets.all(10.0),
                              child: Wrap(
                                spacing: 5.0,
                                children: categoryList.amenities.map((amenity) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: amenity.selected
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
            )
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CustomListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'malgun',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'malgun',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
          primary: color,
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
}
