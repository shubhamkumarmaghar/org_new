import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants/const_strings.dart';
import '../../controller/api_heler_class.dart';
import '../../controller/party_controller.dart';
import '../model/book_party_list_model.dart';

class BookPartyListController extends GetxController {
  String? orgId ='';
  PartyController partyController = Get.find();
 PartyBookingList partyBookingModel = PartyBookingList();




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    orgId = Get.arguments;
    getBookedData();
    //getReportedData();
  }
  ///Booked ticket  data
 Future<void> getBookedData() async {
    try {
      http.Response response = await http.post(
          Uri.parse(API.getPartyBookingHistory),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          },
        body: {'organization_id':orgId,
          'party_id':partyController.partyId.value
          }
      );
      print("response of booked data ${response.body}");


      if (jsonDecode(response.body)['data']!= null ) {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;
        var data=PartyBookingList.fromJson(usersData) ;
        var list = data.data ?? [];
        for(var data1 in list){
         log('transction  id ${data1.id}');
        }

       partyBookingModel = data;

       // dynamic decodedData = jsonDecode(response.body);
      // visitorinfo =  decodedData['data'];
      // return decodedData;

      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in transaction data ${e}');
    }
   update();
  }


}
