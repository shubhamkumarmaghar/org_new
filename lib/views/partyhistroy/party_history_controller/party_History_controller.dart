import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../controller/organisation/dashboard/organization_dashboard.dart';
import '../../../model/partyModel/partyDataModel.dart';

class PartyHistoryController extends GetxController{
  OrganizationDashboardController dashboardController = Get.find();
  RxBool isLoading = false.obs;
  List<Party> allParties = [];
  RxString status = '0'.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllPartiesHistory();
  }
  getAllPartiesHistory() async {
    isLoading.value = true;


    try {
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_user_organization_party_by_id'),
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        },
        body: {
          'organization_id': '${dashboardController.organisationID.value}',
          'status': '0',
        },
      );
      log('abcd ${jsonDecode(response.body)}');
      var decodedData = jsonDecode(response.body);
      if (decodedData != null) {
          status.value = '1';
      }
      //allParties = Party.fromJson(decodedData['data'] as ) as List<Party> ;
      List<dynamic> alldata = decodedData['data'];

      alldata.sort((a, b) {
          DateTime startDateA = DateTime.parse('${a['start_date']}');
          DateTime startDateB = DateTime.parse('${b['start_date']}');
          return startDateA.compareTo(startDateB);
        });


        for(var party in alldata){
          allParties.add(Party.fromJson(party));
        }
        // Reversing the list
        allParties = allParties.reversed.toList();
         log('abcdesd ${allParties[0].title}');
       isLoading.value = false;
        update();
    } catch (error) {
      print('Error: $error');

        status.value = '0';
        isLoading.value = false;
        update();
    }
    update();
  }

}