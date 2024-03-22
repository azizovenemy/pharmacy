import "dart:convert";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import "package:pharmacyapp/constants/constants.dart";
import "package:pharmacyapp/models/category_model.dart";
import "package:pharmacyapp/models/drug_model.dart";

class HomeController extends GetxController {
  RxList<CategoryModel> categoryArr = RxList<CategoryModel>([]);
  RxList<DrugModel> drugArr = RxList<DrugModel>([]);
  final isLoadingCategories = false.obs;
  final isLoadingDrugs = false.obs;

  @override
  void onInit() {
    getAllCategories();
    getAllDrugs();
    super.onInit();
  }

  DrugModel getDrugById(int id) {
    return drugArr.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Drug with id $id not found'),
    );
  }

  Future getAllCategories() async {
    isLoadingCategories.value = true;
    var response = await http.get(
      Uri.parse(url + categories),
      headers: {
        'Application': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        categoryArr.add(CategoryModel.fromJson(item));
      }
    }
    isLoadingCategories.value = false;
  }

  Future getAllDrugs() async {
    isLoadingDrugs.value = true;
    var response = await http.get(
      Uri.parse(url + drugs),
      headers: {
        'Application': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      drugArr.clear();
      for (var item in json.decode(response.body)['drugs']) {
        drugArr.add(DrugModel.fromJson(item));
      }
    }
    isLoadingDrugs.value = false;
  }

  Future getDrugsByCategory(int categoryId) async {
    isLoadingDrugs.value = true;
    var response = await http.get(
      Uri.parse(url + drugsByCategory + categoryId.toString()),
      headers: {
        'Application': 'application/json',
      },
    );
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      drugArr.clear();
      for (var item in jsonResponse['drugs']) {
        drugArr.add(DrugModel.fromJson(item));
      }
    }
    isLoadingDrugs.value = false;
  }

  Future getDrugsByText(String text) async {
    isLoadingDrugs.value = true;
    var response = await http.get(
      Uri.parse(url + drugsByText + text),
      headers: {
        'Application': 'application/json',
      },
    );
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      drugArr.clear();
      for (var item in jsonResponse['drugs']) {
        drugArr.add(DrugModel.fromJson(item));
      }
    }
    isLoadingDrugs.value = false;
  }
}
