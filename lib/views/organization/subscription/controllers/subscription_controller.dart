import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';

import 'subscription_model.dart';

class SubscriptionController extends GetxController {
  //TODO: Implement SubscriptionController
  int count = -1.obs;
  Subscriptions? subscriptions;
  var isLoading = false.obs;
  RxInt quantitySelect = 1.obs;
  RxInt discountPercentage = 1.obs;
  RxInt subscriptionAmount = 499.obs;
  RxInt totalAmount = 499.obs;

  ///Call this function if payment was successfull
  oderIdPlaced(String partyID, String startDate, String endDate) async {
    http.Response response = await http.post(
        Uri.parse('https://app.partypeople.in/v1/order/create_order'),
        body: {
          'party_id': partyID,
          'amount': '499',
          'papular_status': '1',
          'pr_start_date': startDate,
          'pr_end_date': endDate
        },
        headers: {
          "x-access-token": '${GetStorage().read('token')}'
        });

    print(jsonDecode(response.body));

    Get.snackbar('Success', '${jsonDecode(response.body)['message']}');
    Get.offAll(OrganisationDashboard());
  }
}
