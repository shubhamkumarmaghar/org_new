import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants/const_strings.dart';
import '../model/transction_info_model.dart';

class TransctionReportController extends GetxController {
 //APIService apiService = Get.put(APIService());

 TransctionModel transctionModel = TransctionModel();



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTransactionData();
    //getReportedData();
  }
  ///Blocked  data
 Future<void> getTransactionData() async {
    try {
      http.Response response = await http.post(
          Uri.parse(API.getSubscriptionTransactionHistory),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });

      print("response of block data ${response.body}");


      if (jsonDecode(response.body)['data']!= null ) {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;
        var data=TransctionModel.fromJson(usersData) ;
        var list = data.data ?? [];
        for(var data1 in list){
         log('transaction  id ${data1.id}');
        }

       transctionModel = data;

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
