import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';

import '../../../constants/const_strings.dart';
import '../../../model/partyModel/partyDataModel.dart';

class OrganizationDashboardController extends GetxController {
  //TODO: Implement OrganizationProfileNewController
  RxString notificationCount = '0'.obs;
  RxString likes = '0'.obs;
  RxString views = '0'.obs;
  RxString bluetick = '0'.obs;
  RxString imageApproval = '0'.obs;
  RxString approvalStatus = '0'.obs;
  RxString going = '0'.obs;
  RxInt count = 0.obs;
  RxString token = ''.obs;
  RxString organisationName = 'Organisation Name'.obs;
  RxString organisationRating = '0'.obs;
  RxString partyStartTime = ''.obs;
  RxString partyDesc = ''.obs;
  RxString popularPartyVerification = '0'.obs;
  RxString organisationVerification = '0'.obs;
  RxString partyLike = ''.obs;
  RxString partyView = ''.obs;
  RxString partyOngoing = ''.obs;
  RxString timelinePic = ''.obs;
  RxString profileImgB =''.obs;
  RxString profileImgC =''.obs;
  RxString profileImgD =''.obs;
  RxString profileImgE =''.obs;
  RxString organizationDesc = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString circularDP = ''.obs;
  var amenities;
  RxString organisationID = ''.obs;
  RxInt lengthOfTodayParties = 0.obs;
  RxInt lengthOfTommParties = 0.obs;
  RxInt lengthOfUpcomingParties = 0.obs;
  RxString phoneNumber = ''.obs;

  RxList<Party> jsonPartyOrganisationDataToday = <Party>[].obs;

  RxList<Party> jsonPartyOrganisationDataTomm = <Party>[].obs;

  RxList<Party> jsonPartyOgranisationDataUpcomming = <Party>[].obs;

  RxList<Party> jsonPartyPopularData = <Party>[].obs;

  RxInt popularPartyLength = 0.obs;
  RxBool isLoading = false.obs;
  var fullOrganizationData;

  @override
  void onInit() {

    super.onInit();

    getAPIOverview();

    /*Timer.periodic(Duration(seconds: 3), (timer) {
      getAPIOverview();
    });*/
  }


  Future<void> getAPIOverview() async {
    isLoading.value = true;
    if (GetStorage().read('token') != null) {
      final response = await http.post(
        Uri.parse(API.organizationDetails),
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      final data = jsonDecode(response.body)['data'][0];
      print("Organization Data :=> ${data}");
      organisationID.value = data['id'].toString();
      fullOrganizationData = data;
      phoneNumber.value = jsonDecode(response.body)['user_phone_number'];
      notificationCount.value =
          jsonDecode(response.body)['notification_count'].toString();
      timelinePic.value = data['timeline_pic'];
      circularDP.value = data['profile_pic'];
      if(data['profile_pic_b'] != null){
        profileImgB.value = data['profile_pic_b'];
      }
      if(data['profile_pic_c'] != null){
        profileImgC.value = data['profile_pic_c'];
      }
      if(data['profile_pic_d'] != null){
        profileImgD.value = data['profile_pic_d'];
      }
      if(data['profile_pic_e'] != null){
        profileImgE.value = data['profile_pic_e'];
      }




      likes.value = _formatNumber(data['like']);
      views.value = _formatNumber(data['view']);
      going.value = _formatNumber(data['ongoing']);
      organisationName.value = data['name'];
      approvalStatus.value = data['approval_status'];
      bluetick.value = data['bluetick_status'];
      popularPartyVerification.value = data['profile_pic_approval_status'];
      organisationVerification.value = data['approval_status'];
      organisationRating.value = data['rating'];
      organizationDesc.value = data['description'];
      imageApproval.value = data['profile_pic_approval_status'];
      update();
      await getPartyByDate();
      await getOrganisationDetailsPopular();
      isLoading.value = false;
    }

    isLoading.value = false;
  }

  String _formatNumber(String number) {
    final intNumber = int.parse(number);

    if (intNumber >= 1000000) {
      final millions = intNumber / 1000000;
      return '${millions.toStringAsFixed(1)}M';
    } else if (intNumber >= 1000) {
      final thousands = intNumber / 1000;
      return '${thousands.toStringAsFixed(1)}K';
    } else {
      return intNumber.toString();
    }
  }

  String formatNumber(String numberString) {
    final number = int.parse(numberString);
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  Future<void> getPartyByDate() async {
    // status = 0 for all parties
    try {
      log('tokennnnnnnnnnnnn ${GetStorage().read('token')}');
      http.Response response = await http.post(
        Uri.parse(
            API.getPartyById),
        body: {
          'organization_id': organisationID.value.toString(),
          'status': '0'
        },
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);
      print(decodedData);

      // Initialize lists to store parties
      List<Party> todayParties = [];
      List<Party> tomorrowParties = [];
      List<Party> upcomingParties = [];

      // Get current date
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = today.add(Duration(days: 1));

      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        allParties.sort((a, b) {
          DateTime startDateA = DateTime.parse(a['start_date']);
          DateTime startDateB = DateTime.parse(b['start_date']);
          return startDateA.compareTo(startDateB);
        });
        for (var party in allParties) {
          log('gkjhgh');
          DateTime startDate = DateTime.parse(party['start_date']);
          log('gkjhgh  ${startDate.toString()}');
          log(party.toString());
          Party parsedParty = Party.fromJson(party);
          log('gkjhgh  ${parsedParty.startDate}');
          if (startDate.isAtSameMomentAs(today)) {
            todayParties.add(parsedParty);
          } else if (startDate.isAtSameMomentAs(tomorrow)) {
            tomorrowParties.add(parsedParty);
          } else if (startDate.isAfter(tomorrow)) {
            upcomingParties.add(parsedParty);
          }
        }
      }

      // Print the parties in each list
      print('Today parties:');
      print(todayParties.length);

      print('Tomorrow parties:');
      print(tomorrowParties.length);

      print('Upcoming parties:');
      print(upcomingParties.length);

      jsonPartyOrganisationDataToday.value = todayParties;
      lengthOfTodayParties.value = todayParties.length;
      jsonPartyOrganisationDataTomm.value = tomorrowParties;
      lengthOfTommParties.value = tomorrowParties.length;
      jsonPartyOgranisationDataUpcomming.value = upcomingParties;
      lengthOfUpcomingParties.value = upcomingParties.length;

      await http.post(
        Uri.parse(
            API.updateRegularPartiesStatus),
      );

      update();
    } catch (e) {
      print("Exception at getPartyByDate => $e");
    }
  }


  getOrganisationDetailsPopular() async {
    //status = 5 for popular parties
    http.Response response = await http.post(
        Uri.parse(
            API.getPartyById),
        body: {
          'organization_id': organisationID.value.toString(),
          'status': '5'
        },
        headers: {
          'x-access-token': '${GetStorage().read('token')}'
        });

    dynamic jsonDecodedData = {};
    try {
      jsonDecodedData = jsonDecode(response.body);
    } catch (e) {
      print('Error decoding JSON: $e');
    }
    List<Party> popularParties = [];
    if (jsonDecodedData['data'] != null) {
      if (jsonDecodedData['data'].length != 0) {
        List<dynamic> allPopularParties = jsonDecodedData['data'];
        jsonPartyPopularData.clear();
        for(var party in allPopularParties)
          {
            popularParties.add(Party.fromJson(party));
          }
        jsonPartyPopularData.value = popularParties;
        popularPartyLength.value = jsonPartyPopularData.length;
      }
    }
  }

}
