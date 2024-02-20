import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:partypeoplebusiness/controller/organisation/dashboard/organization_dashboard.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';

import '../constants/const_strings.dart';
import '../constants/statecity/model/state_model.dart';
import '../model/partyModel/partyDataModel.dart';
import '../model/subscription_plan_model/subscription_plan_model.dart';
import '../widgets/location_services.dart';

class PartyController extends GetxController {

  List statenNameList = [];
  List cityNameList = [];
  List<StateName> stateName = [] ;
  List<StateName> cityName = [] ;
  var isComplet = false.obs;
  RxInt numberOfDays = 1.obs;
  RxBool isLoading = false.obs;
  TextEditingController pincode = TextEditingController();
  RxList selectedAmenities = [].obs;
  static final count = false.obs;
  static var address = "";
  RxInt photoSelectNo = 0.obs;
  RxString lat=''.obs;
  RxString lng=''.obs;
  File image_c =File('');
  File image_b = File('');
  File cover_img = File('');

  var date = TextEditingController();
  var mobileNumber = TextEditingController();
  final title = TextEditingController();
  var name = '';

  List genderList = [];
  RxString timeline = ''.obs;
  RxString imageB = ''.obs;
  RxString imageC = ''.obs;
  var email = TextEditingController();
  final description = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final popular_start_date = TextEditingController();
  final popular_end_date = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  var location = TextEditingController();
  final image = TextEditingController();
  final partyType = "Music event".obs;
  final gender = TextEditingController();
  final startPeopleAge = TextEditingController();
  final endPeopleAge = TextEditingController();
  final peopleLimit = TextEditingController();
  final discountAmount = TextEditingController();
  final maxMinAmount = TextEditingController();
  final discountDescription = TextEditingController();
  final partyStatus = TextEditingController();
  final ladiesPrice = TextEditingController();
  final stagPrice = TextEditingController();
  final couplesPrice = TextEditingController();
  final othersPrice = TextEditingController();
  final offersText = TextEditingController();
  var county = ''.obs;
  var state = 'Select State'.obs;
  var city = 'Select City'.obs;
  RxString partyId= ''.obs;
  RxBool isPopular = false.obs;
  RxBool discountPortion = false.obs;
  var partyStatusChange = "".obs;

  late Party getPrefiledData;
  RxBool isEditable = false.obs;
  RxBool isRepostParty = false.obs;

  SubscriptionPlanModel subscriptionModel = SubscriptionPlanModel(subsData: []);
  List<SubscriptionData> subsList = [];

  List<bool> listDiscount = [true, false];

  void setChip({required int selectedIndex}) {
    listDiscount = listDiscount.map((e) => false).toList();
    listDiscount[selectedIndex] = true;
    update();
  }
  @override
  void dispose() {
    timeline.value = '';
    imageB.value='';
    imageC.value='';
    image_b = File('');
    image_c = File('');
    cover_img = File('');
    title.text = '';
    description.text = '';
    mobileNumber.text = '';
    startDate.text = '';
    endDate.text = '';
    startTime.text = '';
    endTime.text = '';
    peopleLimit.text = '';
    startPeopleAge.text = '';
    endPeopleAge.text = '';
    offersText.text = '';
    ladiesPrice.text = '';
    stagPrice.text = '';
    othersPrice.text = '';
    couplesPrice.text = '';
    email.text='';
    partyId.value = '';
    state.value = '';
    city.value = '';
    discountPortion.value=false;
    discountAmount.text = '';
    discountDescription.text ='';
    maxMinAmount.text ='';


    super.dispose();
  }

  getEndDate(BuildContext context) async {


    DateTime selectedDate = DateTime.now();
    print('Time');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startingDate,
        firstDate: startingDate,
        lastDate: startingDate.add(Duration(days: 1)) );
    if (picked != null && picked != selectedDate) {
      var date = picked.toString().split(" ");
      var date1 = date[0].split("-");
      var date2 = "${date1[2]}-${date1[1]}-${date1[0]}";
      endDate.text = date2;
    }
  }

  void getEndDatePop(
      BuildContext context, DateTime firstDate, DateTime lastDate) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      popular_end_date.text = formattedDate;
      if (popular_start_date.text.isNotEmpty) {
        DateTime startDate =
            DateFormat('dd-MM-yyyy').parse(popular_start_date.text);
        DateTime endDate =
            DateFormat('dd-MM-yyyy').parse(popular_end_date.text);
        if (endDate.isBefore(startDate)) {
          popular_end_date.text = DateFormat('dd-MM-yyyy').format(startDate);
          showInvalidDateError(context);
          return;
        }
      }
      calculateDuration();
    }
  }

  void getStartDatePop(
      BuildContext context, DateTime firstDate, DateTime lastDate) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      popular_start_date.text = formattedDate;
      if (popular_end_date.text.isNotEmpty) {
        DateTime startDate =
            DateFormat('dd-MM-yyyy').parse(popular_start_date.text);
        DateTime endDate =
            DateFormat('dd-MM-yyyy').parse(popular_end_date.text);
        if (startDate.isAfter(endDate) || startDate.isAtSameMomentAs(endDate)) {
          popular_end_date.text =
              DateFormat('dd-MM-yyyy').format(startDate.add(Duration(days: 1)));
          showInvalidDateError(context);
          return;
        }
      }
      calculateDuration();
    }
  }

  void calculateDuration() {
    if (popular_start_date.text.isNotEmpty &&
        popular_end_date.text.isNotEmpty) {
      DateTime startDate =
          DateFormat('dd-MM-yyyy').parse(popular_start_date.text);
      DateTime endDate = DateFormat('dd-MM-yyyy').parse(popular_end_date.text);
      Duration difference = endDate.difference(startDate);
      int numberOfDayss = difference.inDays;
      if (numberOfDayss < 0) {
        popular_end_date.text = popular_start_date.text;
        // showInvalidDateError();
        return;
      }
      if (numberOfDayss == 0) {
        numberOfDayss = 1;
      }
      print("Number of days: $numberOfDayss");
      numberOfDays.value = numberOfDayss;

      update();
      // Update any necessary variables or UI elements with the calculated result
      // For example:
      // durationTextWidget.text = numberOfDays.toString();
    }
  }

  void showInvalidDateError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Date'),
          content: Text('The end date cannot be earlier than the start date.'),
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
  }

  late DateTime startingDate;

  getStartDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    print('Time');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print('picked Date : ${picked}');
      startingDate = picked;
      var date = picked.toString().split(" ");
      var date1 = date[0].split("-");
      var date2 = "${date1[2]}-${date1[1]}-${date1[0]}";
      startDate.text = date2;
    }
  }

  getStartTime(BuildContext context) async {
    final TimeOfDay? result = await showTimePicker(
        context: context, initialTime: TimeOfDay.now() /*...*/);
    if (result != null) {
      print(result.period); // DayPeriod.pm or DayPeriod.am
      print(result.hour);
      print(result.minute);
      var hour = result.hour.toString().length == 1
          ? '0${result.hour.toString()}'
          : result.hour.toString();
      var min = result.minute.toString().length == 1
          ? '0${result.minute.toString()}'
          : result.minute.toString();
      startTime.text = "$hour:$min";
    }
  }

  getEndTime(BuildContext context) async {
    final TimeOfDay? result = await showTimePicker(
        context: context, initialTime: TimeOfDay.now() /*...*/);
    if (result != null) {
      print(result.period); // DayPeriod.pm or DayPeriod.am
      print(result.hour);
      print(result.minute);
      var hour = result.hour.toString().length == 1
          ? '0${result.hour.toString()}'
          : result.hour.toString();
      var min = result.minute.toString().length == 1
          ? '0${result.minute.toString()}'
          : result.minute.toString();
      endTime.text = "$hour:$min";
    }
  }

  var fullEditableData;

  @override
  onInit() {
    super.onInit();
    lat.value=GetStorage().read('lat')??"";
    lng.value = GetStorage().read('lng')??"";
   // getStateData();
    genderList.clear();
  }

  sendEditParty() async {
    isLoading.value = true;
    if (kDebugMode) {
      print("SENDING PARTY PHOTO TO SAVE =>${timeline.value}");
    }

    var headers = {
      'x-access-token': '${GetStorage().read('token')}'
      // 'Cookie': 'ci_session=f72b54d682c45ebf19fcc0fd54cef39508588d0c'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(API.partyUpdate));
    request.fields.addAll({
      'title': title.text,
      'description': description.text,
      'start_date': startDate.text,
      'end_date': endDate.text,
      'start_time': startTime.text,
      'end_time': endTime.text,
     /* 'latitude': location.text,
      'longitude': '$city, $state, India',
      'city':city.toString(),
      'state':state.toString(),
      'country':'India',
      'pincode' : pincode.text,*/
      'latitude': lat.value??'',
      'longitude': lng.value??"",
      'address':'${location.text}',
      //'city':'$location ${city.toString()}',
      'city':'${city.value.toString()}',
      'state':state.toString(),
      'country': 'India',
      'pincode' : pincode.text,
      'type': getPartyType(partyType.value),
      'gender': genderList
          .toString()
          .replaceAll('[', ' ')
          .replaceAll(']', '')
          .toLowerCase()
          .removeAllWhitespace,
      'start_age': startPeopleAge.text,
      'end_age': endPeopleAge.text,
      'person_limit': peopleLimit.text,
      'status': '0',
      'organization_id': organisationProfileController.organisationID.value,
      'party_amenitie_id':
          selectedAmenities.toString().replaceAll('[', ' ').replaceAll(']', ''),
      "phone_number": mobileNumber.text,
      'offers': discountPortion == false ? offersText.text :"",
      'ladies': ladiesPrice.text,
      'stag': stagPrice.text,
      'couples': couplesPrice.text,
      'others': othersPrice.text,
      'party_id': '${getPrefiledData.id}',
      'cover_photo': timeline.value,
      'image_b':imageB.value??'',
      'image_c':imageC.value??'',
      'discount_type':discountPortion == true ? listDiscount[0] == true ? '1':'2':'0',
      'discount_amount':discountPortion == true ? discountAmount.text??'':"",
      'bill_amount':discountPortion == true ? maxMinAmount.text??'':"",
      'discount_description':discountPortion == true ? discountDescription.text.isEmpty ?"":discountDescription.text:"",
      // 'organization_id': '1'
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      isLoading.value = false;

      var json = jsonDecode(await response.stream.bytesToString());
      print(json);
      if (json['status'] == 1) {
        Get.snackbar("", "Party is under review.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
        Get.offAll(const OrganisationDashboard());
      } else {
        Get.snackbar('Hy', json['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
        // Get.offAllNamed('/dashbord');
      }
    } else {
      //print(response.statusCode);
      isLoading.value = false;
      Get.snackbar(response.reasonPhrase!,
          'Something went wrong Status Code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
      // print(response.headers);
    }
  }

  OrganizationDashboardController organisationProfileController =
      Get.put(OrganizationDashboardController());

  // work with firebase
/*
  void savePartyPopular(String partyId, String popular_start_date,
      String popular_end_date, var data) async {
    // Get the Firestore instance.
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a collection reference for the parties.
    CollectionReference partyCollection =
        firestore.collection('popularParties');

    // Set the party data.
    Map<String, dynamic> partyData = {
      'user_id': GetStorage().read('token'),
      'party_id': partyId,
      'popular_Start_Date': '$popular_start_date',
      'End': '$popular_end_date',
      'title': data['title'],
      'description': data['description'],
      'start_date': data['start_date'],
      'end_date': data['end_date'],
      'start_time': data['start_time'],
      'end_time': data['end_time'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
      'type': data['type'],
      'gender': data['gender'],
      'start_age': data['start_age'],
      'end_age': data['end_age'],
      "phone_number": data['phone_number'],
      'person_limit': data['person_limit'],
      'organization_id': data['organization_id'],
      'party_amenitie_id': data['party_amenitie_id'],
      'offers': data['offers'],
      'ladies': data['ladies'],
      'stag': data['stag'],
      'couples': data['couples'],
      'others': data['others'],
      'cover_photo': data['cover_photo'],
    };

    // Add the party data to the parties collection.
    await partyCollection.add(partyData);

    // Print a message to the console.
    print('Party saved successfully!');
  }
*/

  sendRequest() async {
    /// discount_type == 1 {percent wise}
    /// discount_type == 0 {No discount}
    /// discount_type == 2 {Flat off}


    isLoading.value = true;
    var headers = {
      'x-access-token': '${GetStorage().read('token')}'
      // 'Cookie': 'ci_session=f72b54d682c45ebf19fcc0fd54cef39508588d0c'
    };
    Set<String> listGender = {};
  //  listGender.addAll(genderList);
    var request = http.MultipartRequest(
        'POST', Uri.parse(API.partyAdd));
    request.fields.addAll({
      'title': title.text,
      'description': description.text,
      'start_date': startDate.text,
      'end_date': endDate.text,
      'start_time': startTime.text,
      'end_time': endTime.text,
      'latitude': lat.value??'',
      'longitude': lng.value??"",
      'address':'${location.text}',
      //'city':'$location ${city.toString()}',
      'city':'${city.value.toString()}',
      'state':state.toString(),
      'country': 'India',
      'pincode' : pincode.text,
      'type': getPartyType(partyType.value),
      'gender': genderList
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toLowerCase()
          .removeAllWhitespace,
      'start_age': startPeopleAge.text,
      'end_age': endPeopleAge.text,
      "phone_number": mobileNumber.text,
      'person_limit': peopleLimit.text,
      'status': '0',
      'organization_id': organisationProfileController.organisationID.value,
      'party_amenitie_id':
          selectedAmenities.toString().replaceAll('[', ' ').replaceAll(']', ''),
      'offers': discountPortion == false ? offersText.text :"",
      'ladies': ladiesPrice.text,
      'stag': stagPrice.text,
      'couples': couplesPrice.text,
      'others': othersPrice.text,
      'discount_type':discountPortion == true ? listDiscount[0] == true ? '1':'2':'0',
      'discount_amount':discountPortion == true ? discountAmount.text??'':"",
      'bill_amount':discountPortion == true ? maxMinAmount.text??'':"",
      'discount_description':discountPortion == true ? discountDescription.text.isEmpty ?"":discountDescription.text:"",
      if(timeline.value.isNotEmpty && cover_img.path.isEmpty)'cover_photo': timeline.value??'',
      if(imageB.value.isNotEmpty && image_b.path.isEmpty)'image_b':imageB.value??'',
      if(imageC.value.isNotEmpty && image_c.path.isEmpty)'image_c':imageC.value??'',
    });
   // List<dynamic> images = [];
    if(cover_img.path.isNotEmpty){
     final imga = await http.MultipartFile.fromPath('cover_photo',cover_img.path,);
     request.files.add(imga);
}
    if(image_b.path.isNotEmpty){
      final imgb = await http.MultipartFile.fromPath('image_b',image_b.path,);
      request.files.add(imgb);
    }
    if(image_c.path.isNotEmpty) {
      final imgc = await http.MultipartFile.fromPath('image_c', image_c.path,);
      request.files.add(imgc);
    }
    //log('ddddd ${imga.contentType} - ${imga.field} - ${imga.filename}');
   // request.files.addAllIf(( http.MultipartFile item)=>item.field.isNotEmpty, [imga,imgb,imgc]);
   // request.files.addAll([]);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      isLoading.value = false;
      var json = jsonDecode(await response.stream.bytesToString());
      print(json);
      if (json['status'] == 1) {
        Get.snackbar("", "Party is under review.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
        Get.offAll(const OrganisationDashboard());
      } else {
        Get.snackbar('Hy', json['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
        // Get.offAllNamed('/dashbord');
      }
    }
    else {
      //print(response.statusCode);
      isLoading.value = false;
      Get.snackbar(response.reasonPhrase!,
          'Something went wrong Status Code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
      log('${response}');
      // print(response.headers);
    }
  }

  getPartyType(String gender) {
    switch (gender) {
      case 'Music event':
        return '1';
      case 'Light show':
        return '2';
      case 'Neon party':
        return '3';
    }
  }

   Future<void> getStateData() async {
     isLoading.value =true;
    final response = await http.post(
      Uri.parse(API.getStates),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },

    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('Data Found')) {
        var data= StateCityModel.fromJson(jsonResponse) ;
        var list = data.data ?? [] ;
        stateName= list ;
        cityName.clear();
        statenNameList.add('Select State');
        stateName.forEach((element) {
          statenNameList.add(element.name);
        });
isLoading.value =false;
        update();
      }
      else {
        print('else  Data not found');

        //isLiked= false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch data ');

    }
  }


  Future<void> getCityData({required String cityid}) async {
    try {
      final response = await http.post(
          Uri.parse(API.getCities),
          headers: <String, String>{
            'x-access-token': '${GetStorage().read('token')}',
          },
          body: {'state_id': cityid,}

      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == 1 &&
            jsonResponse['message'].contains('Data Found')) {
          //  cityName = jsonResponse['data'];
          var data = StateCityModel.fromJson(jsonResponse);
          var list = data.data ?? [];
          cityName = list;

          cityNameList.add('Select City');
          cityName.forEach((element) {
            // stateItemss  = [{element.id:element.name},];
            cityNameList.add(element.name);
          });
          log('abcde $cityNameList');
          update();
        }
        else {
          print('else  Data not found');

          //isLiked= false;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to fetch data ');
      }
    }
    catch(e){
      log('error: $e');
    }
  }

  Future<void> getSubscriptionPlan() async {
    try {
      final response = await http.post(
          Uri.parse(API.getSubscriptionPlan),
          headers: <String, String>{
            'x-access-token': '${GetStorage().read('token')}',
          },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == 1 &&
            jsonResponse['message'].contains('Data Found')) {
          //  cityName = jsonResponse['data'];
          var data = SubscriptionPlanModel.fromJson(jsonResponse);
          subscriptionModel = data;
          update();
        }
        else {
          print('else  Data not found');

          //isLiked= false;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to fetch data ');
      }
    }
    catch(e){
      log('error: $e');
    }
  }

  Future<void> partystopResume({required String status , required String partyId})async {
try{

  final response = await http.post(
    Uri.parse(API.partyPauseResume),
    body: {
      'party_id':'315',
      'status':'0',
    },
    headers: <String, String>{
      'x-access-token': '${GetStorage().read('token')}',
    },
  );

  if(response.statusCode == 200){
    var jsonResponse = jsonDecode(response.body);
    log('data ::$jsonResponse');
update();
  }
}
catch(e){
  log('error:: $e');
}
  }

  Future<void> userLocation()async{

    bool? granted=await LocationService.checkPermissionForLocation();

    if( granted != null && granted){
      await LocationService.getCurrentPosition().then((value) {
        log("lat lang ${value.toJson().toString()}");
        lat.value = value.latitude.toString();
        lng.value = value.longitude.toString();
      });
      Position position = await LocationService.getCurrentPosition();
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      log('Address :: '+placeMarks[0].toString());
      String currentAddress =
          '${placeMarks[0].name} ${placeMarks[0].subThoroughfare} ${placeMarks[0].thoroughfare}  ${placeMarks[0].subLocality?.replaceAll(' ', '-')}-${placeMarks[0].locality?.replaceAll(' ', '-')}-${placeMarks[0].administrativeArea?.replaceAll(' ', '-')}-${placeMarks[0].country?.replaceAll(' ', '-')}  ${placeMarks[0].postalCode} ';
      log('current address $currentAddress');
      location.text= await currentAddress;
      county.value = await'${placeMarks[0].country?.replaceAll(' ', '')}';
      state.value = await '${placeMarks[0].administrativeArea?.replaceAll(' ', '')}';
      if(state.value !="" || state.value != 'Select State'){
        cityNameList.clear();
        cityName.clear();
        await getCityData(cityid: '${state}');
        city.value = await '${placeMarks[0].locality}';
      }
      pincode.text = await '${placeMarks[0].postalCode}';
      log('$county $state $city');

    }
    else{
      Fluttertoast.showToast(msg: "Location permission not granted",textColor: Colors.white,);
    }
  }


  @override
  void onClose() {
    stateName.clear();
    cityName.clear();
    super.onClose();
  }
}
