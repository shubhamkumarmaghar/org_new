import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../constants/const_strings.dart';
import '../../controller/organisation/dashboard/organization_dashboard.dart';
import '../../org_book_party_report/model/book_party_list_model.dart';

class BookSinglePartyTicketController extends GetxController {
  OrganizationDashboardController dashboardController = Get.find();
  String? partyTicketId = '';
  PartyBookingList partySingleBookingModel = PartyBookingList();
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    partyTicketId = Get.arguments;
    getData();
    // getSingleBookedTicket();
    //getReportedData();
  }

  void getData() async {
    await getSingleBookedTicket();
  }

  Future<void> getSingleBookedTicket() async {
    try {
      isLoading = true;
      http.Response response =
          await http.post(Uri.parse(API.getPartyBookingHistory), headers: {
        'x-access-token': '${GetStorage().read('token')}',
      }, body: {
        'organization_id': dashboardController.organisationID.value,
        'pj_id': partyTicketId
      });
      print("response of Single booked data ${response.body}");

      if (jsonDecode(response.body)['data'] != null) {
        var usersData = jsonDecode(response.body) as Map<String, dynamic>;
        var data = PartyBookingList.fromJson(usersData);

        // var list = data ?? [];
        /* for(var data1 in list){
          log('transaction  id ${data1.id}');
        }*/

        partySingleBookingModel = data;

        isLoading = false;
        update();
      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in transaction data ${e}');
    }
    update();
  }

  Future<void> approveRejectTicket() async {
    try {
     // isLoading = true;
      http.Response response =
      await http.post(Uri.parse(API.partyApprovalRejectStatus), headers: {
        'x-access-token': '${GetStorage().read('token')}',
      }, body: {
        'organization_id': dashboardController.organisationID.value,
        'pj_id': partyTicketId
      });
      print("response of ticket approval status  ${response.body}");

      if (jsonDecode(response.body)['message'] != null) {
        log('response ${response.body}');
       Fluttertoast.showToast(msg: '${jsonDecode(response.body)['message']}');
     //   var usersData = jsonDecode(response.body) as Map<String, dynamic>;
       // var data = PartyBookingList.fromJson(usersData);

        // var list = data ?? [];
        /* for(var data1 in list){
          log('transaction  id ${data1.id}');
        }*/

       // partySingleBookingModel = data;

       // isLoading = false;
        update();
      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in transaction data ${e}');
    }
    update();
  }

}
