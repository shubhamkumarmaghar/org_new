import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  dynamic jsonPartyOgranisationDataToday = {}.obs;

  dynamic jsonPartyOgranisationDataTomm = {}.obs;

  dynamic jsonPartyPopularData = {}.obs;

  dynamic jsonPartyOgranisationDataUpcomming = {}.obs;

  RxInt popularPartyLength = 0.obs;
  RxBool isLoading = false.obs;
  var fullOrganizationData;

  @override
  void onInit() {
    super.onInit();
    getAPIOverview();

    Timer.periodic(Duration(seconds: 3), (timer) {
      getAPIOverview();
    });
  }

  Future<void> getAPIOverview() async {
    isLoading.value = true;
    if (GetStorage().read('token') != null) {
      final response = await http.post(
        Uri.parse('http://app.partypeople.in/v1/party/organization_details'),
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
    try {
      http.Response response = await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/party/get_user_organization_party_by_id'),
        body: {
          'organization_id': organisationID.value.toString(),
          'status': '0'
        },
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );
      dynamic decodedData = jsonDecode(response.body);
      print(decodedData);

      // Initialize lists to store parties
      List<dynamic> todayParties = [];
      List<dynamic> tomorrowParties = [];
      List<dynamic> upcomingParties = [];

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
          DateTime startDate = DateTime.parse(party['start_date']);
          if (startDate.isAtSameMomentAs(today)) {
            todayParties.add(party);
          } else if (startDate.isAtSameMomentAs(tomorrow)) {
            tomorrowParties.add(party);
          } else if (startDate.isAfter(tomorrow)) {
            upcomingParties.add(party);
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

      jsonPartyOgranisationDataToday = todayParties;
      lengthOfTodayParties.value = todayParties.length;
      jsonPartyOgranisationDataTomm = tomorrowParties;
      lengthOfTommParties.value = tomorrowParties.length;
      jsonPartyOgranisationDataUpcomming = upcomingParties;
      lengthOfUpcomingParties.value = upcomingParties.length;

      await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/order/update_ragular_papular_status'),
      );

      update();
    } catch (e) {
      print("Exception at getPartyByDate => $e");
    }
  }

  getOrganisationDetailsPopular() async {
    http.Response response = await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/party/get_user_organization_party_by_id'),
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
    if (jsonDecodedData['data'] != null) {
      if (jsonDecodedData['data'].length != 0) {
        jsonPartyPopularData = jsonDecodedData['data'];
        popularPartyLength.value = jsonDecodedData['data'].length;
      }
    }
  }
}
