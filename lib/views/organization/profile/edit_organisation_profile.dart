import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:partypeoplebusiness/default_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/cached_image_placeholder.dart';
import '../../../constants/const_strings.dart';
import '../../../controller/organisation/create_profile_controller/create_profile_controller.dart';
import 'add_profile_images.dart';

class EditOrganisationProfile extends StatefulWidget {
  const EditOrganisationProfile({Key? key}) : super(key: key);

  @override
  State<EditOrganisationProfile> createState() =>
      _EditOrganisationProfileState();
}

class _EditOrganisationProfileState extends State<EditOrganisationProfile> {
  CreteOrganisationProfileController controller =
      Get.put(CreteOrganisationProfileController());
  DefaultController defaultController = Get.put(DefaultController());
  List<MultiSelectCard> ameList = [];

  Future<void> newAmenities() async {
    setState(() {
      controller.isLoading.value = true;
    });

    // Get organization details
    final organizationResponse = await http.post(
      Uri.parse(API.organizationDetails),
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    final organizationData = await jsonDecode(organizationResponse.body)['data']
        [0]['organization_amenities'];

    // Add amenities from organizationData to selectedAmenitiesListID and ameList
    for (final amenityData in organizationData) {
      final amenityId = amenityData['id'];
      if (!controller.selectedAmenitiesListID.contains(amenityId)) {
        controller.selectedAmenitiesListID.add(amenityId);
      }
      if (!ameList.any((ameItem) => ameItem.value == amenityId)) {
        ameList.add(
          MultiSelectCard(
            value: amenityId,
            enabled: true,
            selected: true,
            label: amenityData['name'],
          ),
        );
      }
    }

    setState(() {
      controller.isLoading.value = false;
    });
  }

  Future<void> getAmenities() async {
    // Get organization details

    await newAmenities();

    // Get all amenities
    final amenitiesResponse = await http.get(
      Uri.parse(API.orgAmenities),
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    final amenitiesData = await jsonDecode(amenitiesResponse.body)['data'];

    // Add amenities from amenitiesData to ameList
    for (final amenityData in amenitiesData) {
      final amenityId = amenityData['id'];
      if (!ameList.any((ameItem) => ameItem.value == amenityId)) {
        ameList.add(
          MultiSelectCard(
            value: amenityId,
            label: amenityData['name'],
          ),
        );
      }
    }

    setState(() {
      controller.isLoading.value = false;
    });
  }

  @override
  void initState() {
    controller.getAPIOverview();
    getAmenities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Obx(
      () => Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/red_background.png"),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('Edit Profile',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        defaultController.defaultControllerType.value = 0;
                        controller.showSelectPhotoOptionsTimeline(context);
                      },
                      child: Obx(
                        () => Stack(
                          children: [
                            Container(
                              height: Get.height*0.4,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: controller.timeline.value != ''
                                  ? controller.isLoading.value == true
                                      ? const Center(
                                          child: CupertinoActivityIndicator(
                                          radius: 15,
                                          color: Colors.black,
                                        ))
                                      : Card(
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),),
                                            child: ClipRRect(borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImageWidget(
                                                imageUrl:
                                                    controller.timeline.value,
                                                width: Get.width,
                                                height: Get.height*0.25,
                                                fit: BoxFit.fill,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                            Icons.error_outline),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                                color:
                                                                    Colors.black,
                                                                radius: 15))),
                                          ))
                                  : Card(
                                      child: Lottie.asset(
                                        'assets/127619-photo-click.json',
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  defaultController
                                      .defaultControllerType.value = 0;
                                  controller
                                      .showSelectPhotoOptionsTimeline(context);
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 10,
                              right: 10,
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    size: 30,
                                    Icons.camera_alt,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///TODO: ADD CACHED IMAGE PLACEHOLDER
                    Positioned(
                      bottom: 5,
                      left: MediaQuery.of(context).size.width / 2.9,
                      child: GestureDetector(
                        onTap: () {
                          defaultController.defaultControllerType.value = 1;
                          controller.showSelectPhotoOptionsProfile(context);
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)),
                            elevation: 5,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: controller.profile.value != ''
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red.shade900,
                                      maxRadius: 40,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        controller.profile.value,
                                      ),
                                    )
                                  :

                              Container(
                                      width: 50,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(99999),
                                      ),
                                      child: Lottie.asset(
                                          fit: BoxFit.cover,
                                          'assets/107137-add-profile-picture.json'),
                                    ),
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    Get.to( AddImageProfile());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: Get.width*0.25,
                      margin: EdgeInsets.only(right: 28),
                      alignment: Alignment.center,
                      height: Get.width*0.08,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                      child: Text('Add Images',
                        style: TextStyle(fontSize: 13.sp,
                          color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),),
                    ),
                  ),
                ),

                TextFieldWithTitle(
                  title: 'Organization Name *',
                  controller: controller.name,
                  maxLength: 30,
                  inputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an organization name';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFieldWithTitle(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an organization description';
                    } else {
                      return null;
                    }
                  },
                  title: 'Organization Description *',
                  maxLength: 120,
                  controller: controller.description,
                  inputType: TextInputType.name,
                ),
                TextFieldWithTitle(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an organization branches';
                    } else {
                      return null;
                    }
                  },
                  title: 'Organization Branches (Optional)',
                  controller: controller.branches,
                  inputType: TextInputType.name,
                ),
                TextFieldWithTitle(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an organization full address';
                    } else {
                      return null;
                    }
                  },
                  title: 'Organization Full Address',
                  controller: controller.fullAddress,
                  inputType: TextInputType.name,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.07,
                  ),
                  child: CSCPicker(
                    showStates: true,
                    showCities: true,
                    layout: Layout.vertical,
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                    dropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                    //Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",

                   // defaultCountry:CscCountry.India,

                    currentCountry: controller.county.value,
                    currentState: controller.state.value,
                    currentCity: controller.city.value,

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 8.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 8.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      print(value);
                      setState(() {
                        controller.county.value = value.toString();
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      print(value);
                      setState(() {
                        if (controller.county.value.isNotEmpty) {
                          controller.state.value = value.toString();
                        }
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      print(value);

                      setState(() {
                        if (controller.state.value.isNotEmpty) {
                          controller.city.value = value.toString();
                        }
                      });
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: Get.height * 0.025),
                  child: Text('Select Amenities *',
                      style: TextStyle(
                        fontFamily: 'malgun',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: ameList
                          .map((item) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item.selected = !item.selected;

                                    if (!controller.selectedAmenitiesListID
                                        .contains(item.value.toString())) {
                                      controller.selectedAmenitiesListID
                                          .add(item.value.toString());
                                    } else {
                                      controller.selectedAmenitiesListID
                                          .remove(item.value.toString());
                                    }
                                  });
                                },
                                child: Chip(
                                  label: Text(
                                    item.label.toString(),
                                    style: TextStyle(
                                        color: item.selected
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  backgroundColor: item.selected
                                      ? Colors.red
                                      : Colors.grey.shade200,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 14),
                  child: controller.isLoading.value == true
                      ? const Center(
                          child: CupertinoActivityIndicator(
                              color: Colors.white, radius: 15),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (controller.name.text.isEmpty) {
                              Get.snackbar('Name', 'Field is empty');
                            } else if (controller.description.text.isEmpty) {
                              Get.snackbar('Description', 'Field is empty');
                            } else if (controller.city.isEmpty) {
                              Get.snackbar('City', 'Field is empty');
                            } else if (controller.county.isEmpty) {
                              Get.snackbar('Country', 'Field is empty');
                            } else if (controller.state.isEmpty) {
                              Get.snackbar('State', 'Field is empty');
                            } else if (controller
                                .selectedAmenitiesListID.isEmpty) {
                              Get.snackbar(
                                  'Amenities', 'Select at least 1 Amenities');
                            } else if (controller.timeline.isEmpty) {
                              Get.snackbar('Cover Photo', 'Select Cover Photo');
                            } else if (controller.profile.isEmpty) {
                              Get.snackbar('Amenities', 'Select Profile Photo');
                            } else if (controller.fullAddress.text.isEmpty) {
                              Get.snackbar(
                                  'Full Address', 'Enter your full address ');
                            } else {
                              controller.updateOrganisation();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.business),
                              const SizedBox(width: 8),
                              Text(
                                'Update Organization Profile',
                                style: TextStyle(fontSize: 12.sp),
                              )
                            ],
                          ),
                        ),
                )),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    )));
  }
}

class AmenitiesButton extends StatelessWidget {
  var onPressed;
  final IconData iconData;
  final String text;

  AmenitiesButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(iconData),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  int? maxLength;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;

  TextFieldWithTitle({
    super.key,
    required this.validator,
    this.maxLength,
    required this.title,
    required this.controller,
    this.inputType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<TextFieldWithTitle> createState() => _TextFieldWithTitleState();
}

class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
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
              maxLength: widget.maxLength,
              controller: widget.controller,
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
                counterText: '',
                border: InputBorder.none,
                hintText: "Enter ${widget.title}",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12.sp),
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
