// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:group_button/group_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:partypeoplebusiness/controller/party_controller.dart';
import 'package:partypeoplebusiness/default_controller.dart';
import 'package:partypeoplebusiness/views/party/party_amenities.dart';
import 'package:sizer/sizer.dart';

import '../../constants/cached_image_placeholder.dart';
import '../../constants/statecity/model/state_model.dart';
import '../../controller/organisation/create_profile_controller/select_photo_options_screen.dart';
import '../../services/services.dart';

//
// class AddOrganizationsEvent2View
//     extends GetView<AddOrganizationsEvent2Controller> {
//

class CreateParty extends StatefulWidget {
  bool isPopular;

  CreateParty({required this.isPopular});

  @override
  State<CreateParty> createState() => _CreatePartyState();
}

class _CreatePartyState extends State<CreateParty> {
  String selectCity = 'Select City';
  String selectState = 'Select State';

  DefaultController defaultController = Get.put(DefaultController());
  PartyController controller = Get.put(PartyController());

  String getRandomString() {
    DateTime now = DateTime.now();
    int randomNum = now.microsecondsSinceEpoch + now.millisecondsSinceEpoch;
    return 'R${randomNum.toString()}';
  }

  Future<String?> savePhotoToFirebase(
      String tokenId, File photo, String imageName) async {
    try {
      controller.isLoading.value = true;

      await FirebaseAuth.instance.signInAnonymously();

      // Initialize Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the photo in Firebase Storage
      Reference photoRef = storage
          .ref()
          .child('$tokenId/PartyPost/${getRandomString()}$imageName.jpg');

      // Upload the photo to Firebase Storage
      await photoRef.putFile(photo);
      // Get the download URL for the photo
      String downloadURL = await photoRef.getDownloadURL();
      controller.timeline.value = downloadURL;
      controller.isLoading.value = false;
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  _pickImageProfile(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 50);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      if (controller.photoSelectNo.value == 0) {
        controller.cover_img = img!;
        if (controller.isEditable.value == true) {
          String url = await uploadImage(
              type: '2',
              imgFile: controller.cover_img,
              id: controller.partyId.value,
              imageKey: 'cover_photo');
          if (url.isNotEmpty) {
            controller.timeline.value = url;
          }
        }
      }
      if (controller.photoSelectNo.value == 1) {
        controller.image_b = img!;
        if (controller.isEditable.value == true) {
          String url = await uploadImage(
              type: '2',
              imgFile: controller.image_b,
              id: controller.partyId.value,
              imageKey: 'image_b');
          if (url.isNotEmpty) {
            controller.imageB.value = url;
          }
        }
      }
      if (controller.photoSelectNo.value == 2) {
        controller.image_c = img!;
        if (controller.isEditable.value == true) {
          String url = await uploadImage(
              type: '2',
              imgFile: controller.image_c,
              id: controller.partyId.value,
              imageKey: 'image_c');
          if (url.isNotEmpty) {
            controller.imageC.value = url;
          }
        }
      }
      //  uploadImage(type: '2',imgFile: img,partyId: controller.partyId.value);
      setState(() {
        /*  savePhotoToFirebase(
                '${GetStorage().read('token')}', img!, 'Party New Event')
            .then((value) {
          controller.timeline.value = value!;
          controller.isLoading.value = false;
        });*/

        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptionsProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImageProfile,
              ),
            );
          }),
    );
  }

  fillFieldPreFilled() async {
    await controller.getStateData();

    controller.timeline.value = '${controller.getPrefiledData.coverPhoto}';
    controller.imageB.value = '${controller.getPrefiledData.imageB}';
    controller.imageC.value = '${controller.getPrefiledData.imageC}';
    controller.title.text = controller.getPrefiledData.title!;
    controller.description.text = controller.getPrefiledData.description!;
    controller.mobileNumber.text = controller.getPrefiledData.phoneNumber!;
    controller.genderList =
        controller.getPrefiledData.gender.toString().split(',');
    controller.genderList.forEach((element) {
      log('qqqqq $element');
    });
    if (controller.isRepostParty.value == true) {
      var todayDate = DateTime.now().toString().split(" ");
      var tomarrowDate =
          DateTime.now().add(Duration(days: 1)).toString().split(" ");
      var todayDate1 = todayDate[0].split("-");
      var todayDate2 = "${todayDate1[2]}-${todayDate1[1]}-${todayDate1[0]}";
      controller.startDate.text = todayDate2;
      var tomarrowDate1 = tomarrowDate[0].split("-");
      var tomarrowDate2 =
          "${tomarrowDate1[2]}-${tomarrowDate1[1]}-${tomarrowDate1[0]}";
      controller.endDate.text = tomarrowDate2;
    } else {
      controller.startDate.text = controller.getPrefiledData.startDate!;
      controller.endDate.text = controller.getPrefiledData.endDate!;
    }

    controller.startTime.text = controller.getPrefiledData.startTime!;
    controller.endTime.text = controller.getPrefiledData.endTime!;
    controller.peopleLimit.text = controller.getPrefiledData.personLimit!;
    controller.startPeopleAge.text = controller.getPrefiledData.startAge!;
    controller.endPeopleAge.text = controller.getPrefiledData.endAge!;
    controller.offersText.text = controller.getPrefiledData.offers!;
    controller.offersText.text ==''?  controller.discountPortion.value = true:controller.discountPortion.value = false;
    controller.ladiesPrice.text = controller.getPrefiledData.ladies!;
    controller.stagPrice.text = controller.getPrefiledData.stag!;
    controller.othersPrice.text = controller.getPrefiledData.others!;
    controller.couplesPrice.text = controller.getPrefiledData.couples!;
    controller.pincode.text = controller.getPrefiledData.pincode!;
    controller.location.text = controller.getPrefiledData.address!;
    controller.lat.value=controller.getPrefiledData.latitude!;
    controller.lng.value=controller.getPrefiledData.longitude!;

    controller.state.value = controller.getPrefiledData.state!;
    controller.city.value = controller.getPrefiledData.city!;
    if(controller.state.value !=''||controller.state.value != 'Select State')
    {
      selectState = controller.state.value;
      await controller.getCityData(cityid: '$selectState');
      selectCity = controller.city.value;
    }

    controller.partyId.value = controller.getPrefiledData.id!;
    controller.maxMinAmount.text = controller.getPrefiledData.billMaxAmount??'';
    controller.discountDescription.text = controller.getPrefiledData.discountDescription??"";
    controller.discountAmount.text = controller.getPrefiledData.discountAmount??"";
    if(controller.getPrefiledData.discountType =='1')
      {
        controller.listDiscount[0] = true;
        controller.listDiscount[1] = false;
      }
    else if (controller.getPrefiledData.discountType =='2')
    {
      controller.listDiscount[1] = true;
      controller.listDiscount[0] = false;
    }
    else{
      controller.listDiscount[0] = true;
      controller.listDiscount[1] = false;
    }
setState(() {

});
  }

  nonField() async {
    await controller.getStateData();
    setState(() {
      controller.timeline.value = '';
      controller.imageB.value = '';
      controller.imageC.value = '';
      controller.image_b = File('');
      controller.image_c = File('');
      controller.cover_img = File('');
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
      controller.pincode.text = '';
      controller.location.text = '';
      controller.city.value = '';
      controller.state.value = '';
      controller.discountPortion.value=false;
      controller.discountAmount.text = '';
      controller.discountDescription.text ='';
      controller.maxMinAmount.text ='';
      controller.lng.value='';
      controller.lat.value='';
    });
  }



  @override
  void initState() {
    if (controller.isEditable.value == true) {
      fillFieldPreFilled();
    } else {
      nonField();
    }
    //getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.timeline.value = '';
    controller.imageC.value = '';
    controller.imageB.value = '';
    controller.image_b = File('');
    controller.image_c = File('');
    controller.cover_img = File('');
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
    controller.isEditable.value = false;
    controller.couplesPrice.text = '';
    controller.lat.value='';
    controller.lng.value='';

    controller.statenNameList.clear();
    controller.cityNameList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade900,
          title: Text(
            "Host New Event",
            style: TextStyle(fontSize: 13.sp),
          ),
          toolbarHeight: 50,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(
          () => controller.isLoading ==false ?SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/mice.png',
                          ),
                          Text(
                            'Host New Event',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 14.sp,
                              color: const Color(0xffc40d0d),
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: false,
                          )
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          defaultController.defaultControllerType.value = 2;
                          controller.photoSelectNo.value = 0;
                          _showSelectPhotoOptionsProfile(context);
                        },
                        child: Obx(() {
                          return Stack(
                            children: [
                              controller.isLoading.value == false
                                  ? Container(
                                      height: Get.height * 0.25,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: (controller
                                                  .timeline.value.isNotEmpty) &&
                                              controller.cover_img.path.isEmpty
                                          ? Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: CachedNetworkImageWidget(
                                                  imageUrl:
                                                      controller.timeline.value,
                                                  width: Get.width,
                                                  height: Get.height * 0.25,
                                                  fit: BoxFit.fill,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                          radius: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                  radius: 15))))
                                          : controller.cover_img.path.isEmpty
                                              ? Card(
                                                  child: Lottie.asset(
                                                    'assets/127619-photo-click.json',
                                                  ),
                                                )
                                              : Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image.file(
                                                      controller.cover_img)),
                                    )
                                  : Container(
                                      child: const Center(
                                        child: CupertinoActivityIndicator(
                                          radius: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  child: IconButton(
                                    onPressed: () {
                                      defaultController
                                          .defaultControllerType.value = 2;
                                      controller.photoSelectNo.value = 0;
                                      _showSelectPhotoOptionsProfile(context);
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Icon(
                                      size: 30,
                                      Icons.camera_alt,
                                      color: Colors.red.shade900,
                                    )),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  textAddMedia(),
                  TextFieldWithTitle(
                    title: 'Party Title',
                    controller: controller.title,
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an party title';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFieldWithTitle(
                    title: 'Party Description',
                    controller: controller.description,
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an party description';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'malgun',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                            controller: controller.mobileNumber,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                  height: 5,
                                  width: 5,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/indian_flag.png',
                                      height: 28,
                                      width: 28,
                                    ),
                                  )),
                              prefixText: ' +91 ',
                              prefixStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 13.sp),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              hintText: "Enter Mobile Number",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 12.sp),
                            ),
                            onChanged: (value) {},

                            // added validator function
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.isPopular.value == false
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getStartDate(context);
                                    },
                                    child: TextFieldWithTitle(
                                      title: 'Start Date',
                                      passGesture: () {
                                        controller.getStartDate(context);
                                      },
                                      controller: controller.startDate,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an start date';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getEndDate(context);
                                    },
                                    child: TextFieldWithTitle(
                                      title: 'End Date',
                                      passGesture: () {
                                        controller.getEndDate(context);
                                      },
                                      controller: controller.endDate,
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
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getStartTime(context);
                                    },
                                    child: TextFieldWithTitle(
                                      passGesture: () {
                                        controller.getStartTime(context);
                                      },
                                      title: 'Start Time',
                                      controller: controller.startTime,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an start time';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getEndTime(context);
                                    },
                                    child: TextFieldWithTitle(
                                      passGesture: () {
                                        controller.getEndTime(context);
                                      },
                                      title: 'End Time',
                                      controller: controller.endTime,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an end time';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  //LocationButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(onTap: ()async{
                      await controller.userLocation();
                      selectState=controller.state.value;
                      selectCity= controller.city.value;
                      setState(() {

                      });
                     // log( controller.fullAddress.text );
                    },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Current Location',style: TextStyle(color: Colors.black),),
                            Icon(Icons.location_on_outlined,color: Colors.black,),
                          ],
                        )),
                  ),
                  TextFieldWithTitle(
                    title: 'Address',
                    controller: controller.location,
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter House number';
                      } else {
                        return null;
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
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
                        hintText: "India",
                        enabled: false,
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(

                      padding: const EdgeInsets.only(
                          left: 24.0,right: 24, top: 14,bottom: 14),
                      child: DropdownButtonFormField<String>(

                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),

                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        value: selectState,
                        onChanged: (newValue) async{
                          selectState = newValue.toString();
                          controller.state.value = selectState;
                          selectCity = 'Select City';
                          log('you selected ${selectState}');
                         controller.cityNameList.clear();
                         await controller.getCityData(cityid: '${selectState}');
                         // cityList(selectState);
                          controller.cityName.clear();
                          setState(() {});
                        },
                        items: controller.statenNameList.map((items) {
                          return DropdownMenuItem<String>(
                            value: items.toString(),
                            child: Text(items.toString()),
                          );
                        }).toList(),
                      )),
                  // for city
                  Container(
                      // width: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 14),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,

                        value: selectCity,
                        onChanged: (newValue) {
                          setState(() {
                            selectCity = newValue.toString();
                            controller.city.value = selectCity;
                          });
                        },

                        items: controller.cityNameList.map((items) {
                          return DropdownMenuItem<String>(
                            value: items.toString(),
                            child: Text(items.toString()),
                          );
                        }).toList(),
                      )),
                  /* Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.07,
                    ),
                    child: CSCPicker(
                      showStates: true,
                      showCities: true,
                      layout: Layout.vertical,
                      flagState: CountryFlag.DISABLE,

                      // headingStyle: TextStyle(
                      //   fontSize: 13.sp,
                      //   fontFamily: 'malgun',
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.black,
                      // ),

                      dropdownDecoration: BoxDecoration(
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

                      //Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
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

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "Country",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",

                      //defaultCountry: CscCountry.India,

                      ///Country Filter [OPTIONAL PARAMETER]
                      // countryFilter: [
                      //   CscCountry.India,
                      //   CscCountry.United_States,
                      //   CscCountry.Canada
                      // ],

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
                          log('country ${controller.county.value}');
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        print(value);
                        setState(() {
                          if (controller.county.value.isNotEmpty) {
                            controller.state.value = value.toString();
                            log('state ${controller.state.value}');
                          }
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        print(value);
                        setState(() {
                          if (controller.state.value.isNotEmpty) {
                            controller.city.value = value.toString();
                            log('city ${controller.city.value}');
                          }
                        });
                      },
                    ),
                  ),


                  */
                  TextFieldWithTitle(
                    title: 'Pin Code ',
                    controller: controller.pincode,
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Pin Code : ';
                      } else {
                        return null;
                      }
                    },
                    maxlength: 6,
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      'Who can join',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'malgun',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  OptionSelector(),

                  Row(
                    children: [
                      Expanded(
                        child: TextFieldWithTitle(
                          title: 'Start Age',
                          controller: controller.startPeopleAge,
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an start age';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFieldWithTitle(
                          title: 'End Age',
                          inputType: TextInputType.number,
                          controller: controller.endPeopleAge,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an end age';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFieldWithTitle(
                    title: 'Party People Limit',
                    controller: controller.peopleLimit,
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter people limit';
                      } else {
                        return null;
                      }
                    },
                  ),
                  controller.discountPortion.value == false
                      ? TextFieldWithTitle(
                    title: 'Offers',
                    controller: controller.offersText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter offers';
                      } else {
                        return null;
                      }
                    },
                  ):Container(),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'malgun',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Switch(
                            value: controller.discountPortion.value,
                            onChanged: (value) {
                              controller.discountPortion.value =
                                  controller.discountPortion.value == false
                                      ? true
                                      : false;
                            })
                      ],
                    ),
                  ),
                  controller.discountPortion.value == true
                      ? discountSection()
                      : Container(),
                  Center(child: AmenitiesButton()),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ):Center(child: CircularProgressIndicator()),
        ));
  }

  Widget discountSection() {
    return Container(
      child: Column(children: [
        Row(
          children: [
            iconText(
              'Percent Wise',
              FilterChip(
                  label: Text('Percent Wise'),
                  selected: controller.listDiscount[0],
                  selectedColor: Colors.red.shade900,
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white),
                  onSelected: (value) {
                    controller.setChip(selectedIndex: 0);
                    //_peopleListController.getPaginatedNearbyPeoples(isRefresh: true ,type: 0);
                    // _peopleListController.showList = _peopleListController.paginatedUsersList;
                    // navigator?.pop();
                    setState(() {});
                  }),
            ),
            iconText(
              'Direct Off',
              FilterChip(
                  label: Text('Direct Off'),
                  selected: controller.listDiscount[1],
                  selectedColor: Colors.red.shade900,
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white),
                  onSelected: (value) {
                    controller.setChip(selectedIndex: 1);
                    //_peopleListController.getPaginatedNearbyPeoples(isRefresh: true ,type: 0);
                    // _peopleListController.showList = _peopleListController.paginatedUsersList;
                    // navigator?.pop();
                    setState(() {});
                  }),
            ),
          ],
        ),
        TextFieldWithTitle(
          title: controller.listDiscount[0] == true
              ? 'Please Enter percent(%) '
              : 'Flat Discount Amount ()',
          controller: controller.discountAmount,
          inputType: TextInputType.number,
          hinttext: controller.listDiscount[0] == true
              ? 'Ex: 10 or 20'
              : 'Ex: 500 or 1000',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter value in number';
            } else {
              return null;
            }
          },
        ),
        TextFieldWithTitle(
          title: controller.listDiscount[0] == true
              ? 'Maximum discount amount (Optional)'
              : 'Flat discount on minimum Spends (Optional)',
          controller: controller.maxMinAmount,
          inputType: TextInputType.number,
          hinttext: 'Ex: 500 or 1000',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return controller.listDiscount[0] == true
                  ? 'Please enter max discount amount'
                  : 'Please enter flat min discount amount';
            } else {
              return null;
            }
          },
        ),
        TextFieldWithTitle(
          title: 'Terms & Conditions (Optional)',
          controller: controller.discountDescription,
          inputType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Description about discount';
            } else {
              return null;
            }
          },
        ),
      ]),
    );
  }

  Widget iconText(String text, Widget widget) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(children: [
        SizedBox(
          width: Get.width * 0.05,
        ),
        widget
      ]),
    );
  }

  Widget textAddMedia() {
    return Container(
      height: Get.height * 0.15,
      width: Get.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
          onTap: () {
            defaultController.defaultControllerType.value = 2;
            controller.photoSelectNo.value = 1;
            _showSelectPhotoOptionsProfile(context);
          },
          child: Obx(() {
            return Stack(
              children: [
                controller.isLoading.value == false
                    ? Container(
                        height: Get.height * 0.15,
                        width: Get.height * 0.2,
                        child: controller.imageB.value.isNotEmpty &&
                                controller.image_b.path.isEmpty
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImageWidget(
                                    imageUrl: controller.imageB.value,
                                    width: Get.height * 0.12,
                                    height: Get.height * 0.12,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Lottie.asset(
                                            'assets/127619-photo-click.json',
                                          ),
                                          /* CupertinoActivityIndicator(
                                      radius: 15,
                                      color: Colors.black,
                                    ),*/
                                        ),
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator(
                                            color: Colors.black, radius: 15))))
                            : controller.image_b.path.isEmpty
                                ? Card(
                                    child: Lottie.asset(
                                      'assets/127619-photo-click.json',
                                    ),
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.file(controller.image_b)),
                      )
                    : Container(
                        child: const Center(
                          child: CupertinoActivityIndicator(
                            radius: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                /* Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            child: IconButton(
                              onPressed: () {
                                defaultController
                                    .defaultControllerType.value = 2;
                               // _showSelectPhotoOptionsProfile(context);
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),*/
              ],
            );
          }),
        ),
        GestureDetector(
          onTap: () {
            defaultController.defaultControllerType.value = 2;
            controller.photoSelectNo.value = 2;
            _showSelectPhotoOptionsProfile(context);
          },
          child: Obx(() {
            return Stack(
              children: [
                controller.isLoading.value == false
                    ? Container(
                        height: Get.height * 0.15,
                        width: Get.height * 0.2,
                        child: (controller.imageC.value.isNotEmpty ||
                                    controller.imageC.value == 'null') &&
                                controller.image_c.path.isEmpty
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImageWidget(
                                    imageUrl: controller.imageC.value,
                                    width: Get.height * 0.12,
                                    height: Get.height * 0.12,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Lottie.asset(
                                            'assets/127619-photo-click.json',
                                          ),
                                          /* CupertinoActivityIndicator(
                                      radius: 15,
                                      color: Colors.black,
                                    ),*/
                                        ),
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator(
                                            color: Colors.black, radius: 15))))
                            : controller.image_c.path.isEmpty
                                ? Card(
                                    child: Lottie.asset(
                                      'assets/127619-photo-click.json',
                                    ),
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.file(controller.image_c)),
                      )
                    : Container(
                        child: const Center(
                          child: CupertinoActivityIndicator(
                            radius: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                /*  Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            child: IconButton(
                              onPressed: () {
                                defaultController
                                    .defaultControllerType.value = 2;
                              //  _showSelectPhotoOptionsProfile(context);
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),*/
              ],
            );
          }),
        ),
      ]),
    );
  }
}

class OptionSelector extends StatefulWidget {
  @override
  _OptionSelectorState createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  bool showLadiesFees = false;
  bool showStagFees = false;
  bool showCoupleFees = false;
  bool showOthersFees = false;
  PartyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GroupButton(
            isRadio: false,
            onSelected: (string, index, isSelected) {
              setState(() {
                if (isSelected) {
                  if (controller.genderList.contains(string.toLowerCase())) {
                    log('already contains--- $string');
                  } else {
                    controller.genderList.add(string);
                    log('contains $string');
                    controller.genderList.forEach((element) {
                      log('$element');
                    });
                  }
                } else {
                  controller.genderList.remove(string);
                  controller.genderList.remove(string.toLowerCase());
                  log('contains remove $string');
                  controller.genderList.forEach((element) {
                    log('$element');
                  });
                }
                showLadiesFees = false;
                showStagFees = false;
                showCoupleFees = false;
                showOthersFees = false;
                if (controller.genderList.contains('Stag') ||
                    controller.genderList.contains('stag')) {
                  showStagFees = true;
                }
                if (controller.genderList.contains('Ladies') ||
                    controller.genderList.contains('ladies')) {
                  showLadiesFees = true;
                }
                if (controller.genderList.contains('Couple') ||
                    controller.genderList.contains('couple')) {
                  showCoupleFees = true;
                }
                if (controller.genderList.contains('Others') ||
                    controller.genderList.contains('others')) {
                  showOthersFees = true;
                }
              });
            },
            options: GroupButtonOptions(
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.red.shade900,
            ),
            buttons: [
              "Stag",
              "Ladies",
              "Couple",
              "Others",
            ],
          ),
          Column(
            children: [
              if (showStagFees)
                TextFieldWithTitle(
                  title: 'Stag Fees (₹)',
                  controller: controller.stagPrice,
                  inputType: TextInputType.number,
                  validator: (value) {},
                ),
              if (showLadiesFees)
                TextFieldWithTitle(
                  title: 'Ladies Fees (₹)',
                  inputType: TextInputType.number,
                  controller: controller.ladiesPrice,
                  validator: (value) {},
                ),
              if (showCoupleFees)
                TextFieldWithTitle(
                  title: 'Couple Fees (₹)',
                  inputType: TextInputType.number,
                  controller: controller.couplesPrice,
                  validator: (value) {},
                ),
              if (showOthersFees)
                TextFieldWithTitle(
                  title: 'Others Fees (₹)',
                  inputType: TextInputType.number,
                  controller: controller.othersPrice,
                  validator: (value) {},
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AmenitiesButton extends StatelessWidget {
  PartyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        bool hasEmptyField = false;
        String emptyFieldTitle = '';
        String emptyFieldMessage = '';
        List<Map<String, String>> fieldsToValidate = [
          {
            'Party Image': controller.cover_img.path.isEmpty
                ? controller.timeline.value
                : controller.cover_img.path
          },
          {'Party Title': controller.title.text},
          {'Party Description': controller.description.text},
          {'Party Start Date': controller.startDate.text},
          {'Party End Date': controller.endDate.text},
          {'Party Start Time': controller.startTime.text},
          {'Party End Time': controller.endTime.text},
          {'Party Start Age': controller.startPeopleAge.text},
          {'Party End Age': controller.endPeopleAge.text},
          {'Party People Limit': controller.peopleLimit.text},
        ];
        for (var field in fieldsToValidate) {
          String title = field.keys.first;
          String value = field.values.first;

          if (value.isEmpty) {
            hasEmptyField = true;
            emptyFieldTitle = title;
            emptyFieldMessage = 'Field Is Empty';
            break;
          }
        }
        if (hasEmptyField) {
          Get.snackbar(emptyFieldTitle, emptyFieldMessage);
          return;
        }
        if (controller.cover_img.path.isEmpty &&
            controller.timeline.value.isEmpty) {
          Get.snackbar("Error ", "Cover Image should not be empty");
          return;
        }
        Get.to(const AmenitiesPartyScreen());
      },
      icon: const Icon(
        Icons.grid_view,
        color: Colors.white,
      ),
      label: Text(
        'Select Amenities',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: const Size(180, 50),
      ),
    );
  }
}

class TextFieldWithTitle extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final int? maxlength;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;
  var passGesture;
  final String hinttext;

  TextFieldWithTitle(
      {required this.validator,
      this.passGesture,
      this.maxlength,
      required this.title,
      required this.controller,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.hinttext = ''});

  @override
  State<TextFieldWithTitle> createState() => _TextFieldWithTitleState();
}

class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
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
              fontSize: 13.sp,
              fontFamily: 'malgun',
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
                hintText: widget.hinttext == ''
                    ? "Enter ${widget.title}"
                    : widget.hinttext,
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
