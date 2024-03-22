import 'dart:convert';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:pharmacyapp/views/main_page.dart';
import 'package:pharmacyapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final hasAuthorized = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthorized();
  }

  Future<void> checkAuthorized() async {
    String? token = await loadData();
    hasAuthorized.value = token != null && token.isNotEmpty;
  }

  Future<String?> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future register(
      {required String firstName,
      required String lastName,
      required String login,
      required String password}) async {
    try {
      isLoading.value = true;
      var data = {
        'first_name': firstName,
        'last_name': lastName,
        'login': login,
        'password': password,
      };
      var response = await http.post(
        Uri.parse(url + reg),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonResponse['token']);
        isLoading.value = false;
        checkAuthorized();
        Get.offAll(() => const MainPage());
      } else {
        isLoading.value = false;
        hasAuthorized.value = false;
        Get.snackbar(
          'Error',
          jsonResponse['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future login({required String login, required String password}) async {
    try {
      isLoading.value = true;
      var data = {
        'login': login,
        'password': password,
      };
      var response = await http.post(
        Uri.parse(url + log),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonResponse['token']);
        isLoading.value = false;
        checkAuthorized();
        Get.offAll(() => const MainPage());
      } else {
        isLoading.value = false;
        hasAuthorized.value = false;
        Get.snackbar(
          'Error',
          jsonResponse['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }
}
