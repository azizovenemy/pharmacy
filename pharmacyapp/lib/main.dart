import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacyapp/views/main_page.dart';

void main() {
  runApp(const Pharmacy());
}

class Pharmacy extends StatelessWidget {
  const Pharmacy({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy App',
      home: MainPage(),
    );
  }
}
