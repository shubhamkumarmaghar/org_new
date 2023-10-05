import 'dart:convert';
import 'dart:developer';
import 'dart:io' ;

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

Future<String> uploadImage({ File? imgFile ,required String type, required String partyId}) async {
  try {
    var headers = {'x-access-token': '${GetStorage().read('token')}'};
    // var dio = Dio();
    //
    // final hhh =await http.MultipartFile.fromPath('image_b',imgFile?.path ??File('').path,);
    // log('dd ${ hhh.filename},${hhh.field}');
    // var formData = FormData.fromMap({
    //   'image_b':hhh,
    //   'type': type,
    //   'party_id': 232.toString(),
    //
    // });
    // var responseDio = await dio.post(
    //     'https://app.partypeople.in/v1/party/add_image',
    //     data: formData,
    //   options: Options(headers: headers)
    // );
    // log('xxxxxx $responseDio');
   var request = http.MultipartRequest('POST',
     Uri.parse('https://app.partypeople.in/v1/party/add_image'),);

    request.fields.addAll({
     'type': type,
    'party_id': 232.toString(),
    });

   final data = await http.MultipartFile.fromPath('image_b',imgFile?.path??File('').path,);
   log('ddddd ${data.contentType} - ${data.field} - ${data.filename}');
   request.files.addAll([data]);

   request.headers.addAll(headers);
   http.StreamedResponse response = await request.send();
   if (response.statusCode == 200) {
     log('${response}');
     var jsonResponse = await response.stream.bytesToString();
    log("abcdefg $jsonResponse" );
    }
  }
  catch(e){
    log("Error  "+ '${e}');
  }
  return"";
}