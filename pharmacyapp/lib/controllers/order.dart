import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacyapp/constants/constants.dart';
import 'package:pharmacyapp/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  final isLoading = false.obs;
  RxList<OrderModel> orderArr = RxList<OrderModel>([]);

  Future getOrders() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var response = await http.get(
      Uri.parse(url + orders),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      orderArr.clear();
      for (var item in json.decode(response.body)['orders']) {
        orderArr.add(OrderModel.fromJson(item));
      }
    }
    isLoading.value = false;
  }
}
