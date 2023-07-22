import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:partypeoplebusiness/controller/organisation/dashboard/organization_dashboard.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';

class PartyController extends GetxController {
  var isComplet = false.obs;
  RxInt numberOfDays = 1.obs;
  var isLoading = false.obs;
  TextEditingController pincode = TextEditingController();
  RxList selectedAmenities = [].obs;
  static final count = false.obs;
  static var address = "";

  var date = TextEditingController();
  var mobileNumber = TextEditingController();
  final title = TextEditingController();
  var name = '';
  var genderList = [];
  RxString timeline = ''.obs;
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
  final partyStatus = TextEditingController();
  final ladiesPrice = TextEditingController();
  final stagPrice = TextEditingController();
  final couplesPrice = TextEditingController();
  final othersPrice = TextEditingController();
  final offersText = TextEditingController();
  RxBool isPopular = false.obs;
  var partyStatusChange = "".obs;

  var getPrefiledData;
  RxBool isEditable = false.obs;

  @override
  void dispose() {
    timeline.value = '';
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
    super.dispose();
  }

  getEndDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    print('Time');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startingDate,
        firstDate: startingDate,
        lastDate: DateTime(2101));
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

  var startingDate;

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
        'POST', Uri.parse('http://app.partypeople.in/v1/party/update'));
    request.fields.addAll({
      'title': title.text,
      'description': description.text,
      'start_date': startDate.text,
      'end_date': endDate.text,
      'start_time': startTime.text,
      'end_time': endTime.text,
      'latitude': location.text,
      'longitude': location.text,
      'type': getPertyType(partyType.value),
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
      'offers': offersText.text,
      'ladies': ladiesPrice.text,
      'stag': stagPrice.text,
      'couples': couplesPrice.text,
      'others': othersPrice.text,

      'party_id': '${getPrefiledData['id']}',
      'cover_photo': timeline.value
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

  sendRequst() async {
    isLoading.value = true;
    var headers = {
      'x-access-token': '${GetStorage().read('token')}'
      // 'Cookie': 'ci_session=f72b54d682c45ebf19fcc0fd54cef39508588d0c'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://app.partypeople.in/v1/party/add'));
    request.fields.addAll({
      'title': title.text,
      'description': description.text,
      'start_date': startDate.text,
      'end_date': endDate.text,
      'start_time': startTime.text,
      'end_time': endTime.text,
      'latitude': location.text,
      'longitude': location.text,
      'type': getPertyType(partyType.value),
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
      'offers': offersText.text,
      'ladies': ladiesPrice.text,
      'stag': stagPrice.text,
      'couples': couplesPrice.text,
      'others': othersPrice.text,
      'cover_photo': timeline.value
    });

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

  getPertyType(String gender) {
    switch (gender) {
      case 'Music event':
        return '1';
      case 'Light show':
        return '2';
      case 'Neon party':
        return '3';
    }
  }
}
