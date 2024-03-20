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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      await http.post(
        Uri.parse(url + cart + id.toString()),
        headers: {
          'Application': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future getCarts() async {
    cartArr.clear();
    try {
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
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future updateQuantity({
    required int id,
    required int amount,
  }) async {
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future deleteCart({
    required int id,
  }) async {
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future createOrder() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var response = await http.post(
        Uri.parse(url + cart),
        headers: {
          'Application': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        cartArr.clear();
      }
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }
}
