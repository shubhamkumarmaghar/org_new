import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeoplebusiness/controller/party_controller.dart';
import 'package:sizer/sizer.dart';

import '../../constants/const_strings.dart';

class Category {
  String id;
  String name;
  List<Amenity> amenities;

  Category({required this.id, required this.name, required this.amenities});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      amenities: (json['amenities'] as List)
          .map((amenity) => Amenity.fromJson(amenity))
          .toList(),
    );
  }
}

class Amenity {
  String id;
  String name;
  String type;
  bool selected;

  Amenity({required this.id,
    required this.name,
    required this.type,
    this.selected = false});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class CategoryList {
  String title;
  List<Amenity> amenities;

  CategoryList({required this.title, required this.amenities});
}

class AmenitiesPartyScreen extends StatefulWidget {
  const AmenitiesPartyScreen({Key? key}) : super(key: key);

  @override
  _AmenitiesPartyScreenState createState() => _AmenitiesPartyScreenState();
}

class _AmenitiesPartyScreenState extends State<AmenitiesPartyScreen> {
  List<Category> _categories = [];
  List<CategoryList> _categoryLists = [];
  PartyController controller = Get.put(PartyController());

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
        if (controller.isEditable.value == true) {
          getSelectedID();
        }
      }
    });
  }

  void _selectAmenity(Amenity amenity) {
    setState(() {
      if (amenity.selected) {
        // amenity is already selected, remove it from the list
        controller.selectedAmenities.remove(amenity.id);
      } else {
        // amenity is not selected, add it to the list
        controller.selectedAmenities.add(amenity.id);
      }
      amenity.selected = !amenity.selected;
    });
  }

  void getSelectedID() {
    print(controller.getPrefiledData.partyAmenitie);
    int? len = controller.getPrefiledData.partyAmenitie?.length;
    for (var i = 0; i < len!; i++) {
      var amenityName = controller.getPrefiledData.partyAmenitie?[i].name;
      print(amenityName);
      setState(() {
        _categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.name == amenityName) {
              if (controller.selectedAmenities.contains(amenity.id)) {} else {
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
    super.initState();

    _fetchData();
  }

/*  @override
  void dispose() {
    controller.timeline.value = '';
    controller.title.text = '';
    controller.description.text = '';
    controller.mobileNumber.text = '';
    controller.startDate.text = '';
    controller.endDate.text = '';
    controller.startTime.text = '';
    controller.endTime.text = '';
    controller.peopleLimit.text = '';
    controller.startPeopleAge.text = '';
    controller.endPeopleAge.text = '';
    controller.offersText.text = '';
    controller.ladiesPrice.text = '';
    controller.stagPrice.text = '';
    controller.othersPrice.text = '';
    controller.couplesPrice.text = '';
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Parties Amenities',
          style: TextStyle(fontSize: 13.sp),
        ),backgroundColor: Colors.red.shade900,
        leading: GestureDetector(onTap:(){
          Navigator.pop(context);},
          child: Icon(Icons.arrow_back,)),
      ),
      body: _categoryLists.isEmpty
          ? Container(
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Colors.black,
          ),
        ),
      )
          : ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: Get.height * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _categoryLists.length,
              itemBuilder: (context, index) {
                final categoryList = _categoryLists[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(categoryList.title,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        spacing: 10.0,
                        children: categoryList.amenities.map((amenity) {
                          return GestureDetector(
                            onTap: () => _selectAmenity(amenity),
                            child: Chip(
                              label: Text(
                                amenity.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontFamily: 'malgun'),
                              ),
                              backgroundColor: amenity.selected
                                  ? Colors.red
                                  : Colors.grey[400],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (index == _categoryLists.length - 1)
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: AmenitiesButton(() {
                              if (controller.isEditable.value == true) {
                                if(controller.isRepostParty.value == true)
                                  {
                                    controller.sendRequest();
                                  }
                                else{
                                  controller.sendEditParty();
                                }

                              } else {
                                controller.sendRequest();
                              }
                            }),
                          ),
                          SizedBox(
                            height: Get.height*0.05,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class AmenitiesButton extends StatefulWidget {
  var onPressed;

  AmenitiesButton(this.onPressed);

  @override
  State<AmenitiesButton> createState() => _AmenitiesButtonState();
}

class _AmenitiesButtonState extends State<AmenitiesButton> {
  PartyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      icon: const Icon(
        Icons.grid_view,
        color: Colors.white,
      ),
      label: controller.isEditable.value == true
          ? controller.isRepostParty.value == true ?
      const Text(
        'Repost Party',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ):
      const Text(
        'Update Party',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )
          : const Text(
        'Create Party',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.red.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: const Size(180, 50),
      ),
    );
  }
}
