import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/statecity/model/state_model.dart';

class APIService extends GetxController {

  final String _baseUrl =
      'https://example.com/api/'; // replace with your base URL

  Future<dynamic> login(
      String username, String password, String device_token) async {
    final response = await _post('login', {
      'username': username,
      'password': password,
      'device_token': device_token
    });

    if (response['status'] == 1) {
      // Login successful, return user data
      return response['data'];
    } else {
      // Handle failure
      throw Exception(response['message']);
    }
  }

  Future<Map<String, dynamic>> _post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(_baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load API endpoint: $endpoint');
      }
    } catch (e) {
      // Using Get.snackbar
      Get.snackbar(
        'Error', // title
        e.toString(), // message
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }


}
