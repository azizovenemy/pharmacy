import 'dart:convert';

import 'package:get/get.dart';
import 'package:pharmacyapp/constants/constants.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final isLoading = false.obs;

  Future getUser() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var response = await http.get(
      Uri.parse(url + user),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      userModel.value = UserModel.fromJson(json.decode(response.body));
    }
    isLoading.value = false;
  }

  void quitAccount() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    isLoading.value = false;
  }
}
