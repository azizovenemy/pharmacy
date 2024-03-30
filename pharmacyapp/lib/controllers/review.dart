import 'dart:convert';

import 'package:get/get.dart';
import 'package:pharmacyapp/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacyapp/models/review_model.dart';

class ReviewController extends GetxController {
  RxList<ReviewModel> reviewArr = RxList<ReviewModel>([]);
  final isLoading = false.obs;

  Future getReviews(int id) async {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(url + reviews + id.toString()),
      headers: {
        'Application': 'application/json',
      },
    );
    reviewArr.clear();
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)['reviews']) {
        reviewArr.add(ReviewModel.fromJson(item));
      }
    }
    isLoading.value = false;
  }
}
