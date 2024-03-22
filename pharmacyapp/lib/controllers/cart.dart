import 'dart:convert';

import 'package:get/get.dart';
import 'package:pharmacyapp/constants/constants.dart';
import 'package:pharmacyapp/controllers/home.dart';
import 'package:pharmacyapp/models/cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final HomeController _drugController = Get.put(HomeController());
  RxList<CartModel> cartArr = RxList<CartModel>([]);
  final isLoading = false.obs;
  var orderCost = double.minPositive;

  double calculateCartCost() {
    orderCost = 0;
    for (var item in cartArr) {
      orderCost +=
          _drugController.getDrugById(item.drugId).price * item.quantity;
    }
    return orderCost;
  }

  double calculateFinalCost(int discount) {
    return orderCost - (orderCost * discount / 100);
  }

  Future addToCart(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await http.post(
      Uri.parse(url + cart + id.toString()),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future getCarts() async {
    cartArr.clear();
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var response = await http.get(
      Uri.parse(url + cart),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        cartArr.add(CartModel.fromJson(item));
      }
    }
    isLoading.value = false;
  }

  Future updateQuantity({
    required int id,
    required int amount,
  }) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var data = {
      'amount': amount.toString(),
    };
    var response = await http.put(
      Uri.parse(url + cart + id.toString()),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: data,
    );
    if (response.statusCode == 200) {
      getCarts();
    }
  }

  Future deleteCart({
    required int id,
  }) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var response = await http.delete(
      Uri.parse(url + cart + id.toString()),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      getCarts();
    }
    isLoading.value = false;
  }

  Future createOrder() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var response = await http.post(
      Uri.parse(url + orders),
      headers: {
        'Application': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      cartArr.clear();
    }
    isLoading.value = false;
  }
}
