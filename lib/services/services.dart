import 'dart:convert';
import 'dart:developer';
import 'dart:io' ;

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../constants/const_strings.dart';

Future<String> uploadImage({ File? imgFile ,required String type, required String id,required String imageKey}) async {
  String url='';
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
    //     API.addImage,
    //     data: formData,
    //   options: Options(headers: headers)
    // );
    // log('xxxxxx $responseDio');
   var request = http.MultipartRequest('POST',
     Uri.parse(API.addImage),);

    request.fields.addAll({
     'type': type,
      if(type=='1')'organization_id':id.toString(),
      if(type=='2')'party_id': id.toString(),
    });

   final data = await http.MultipartFile.fromPath(imageKey,imgFile?.path??File('').path,);
   log('ddddd ${data.contentType} - ${data.field} - ${data.filename}');
   request.files.addAll([data]);

   request.headers.addAll(headers);
   http.StreamedResponse response = await request.send();
    var response1 = await http.Response.fromStream(response);
   if (response1.statusCode == 200) {
     var parsed = jsonDecode(response1.body);
     log('${response}  -- ${response1}  -- ${parsed['url']}');
     url= '${parsed['url']}';
     //var jsonResponse = await response.stream.bytesToString();

  //  log("response :: $jsonResponse " );

    }
  }
  catch(e){
    log("Error  "+ '${e}');
  }
  return url;
}