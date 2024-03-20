import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:pharmacyapp/controllers/authentication.dart";
import "package:pharmacyapp/controllers/order.dart";
import "package:pharmacyapp/controllers/profile.dart";
import "package:pharmacyapp/views/auth_views/login_page.dart";
import "package:google_fonts/google_fonts.dart";
import "package:pharmacyapp/views/widgets/orders_dialog.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  final ProfileController _controller = Get.put(ProfileController());
  final OrderController _orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Obx(() {
            return _authenticationController.hasAuthorized.value
                ? registeredView(screenSize)
                : unregistredView(screenSize);
          }),
        ),
      ),
    );
  }

  Column unregistredView(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 10,
            ),
          ),
          onPressed: () {
            Get.to(() => const LoginPage());
          },
          child: Text(
            'Войти',
            style: GoogleFonts.roboto(fontSize: size.width * 0.040),
          ),
        ),
      ],
    );
  }

  Widget registeredView(Size screenSize) {
    final user = _controller.userModel.value;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    _orderController.getOrders();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        Text(
          'Имя: ${user.firstName}',
          style: GoogleFonts.roboto(
            color: const Color(0xff101617),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Фамилия: ${user.lastName}',
          style: GoogleFonts.roboto(
            color: const Color(0xff101617),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pinkAccent.withOpacity(0.1),
            border: Border.all(color: Colors.pinkAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Ваша скидка: 25%',
            style: GoogleFonts.roboto(
              fontSize: 22,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 140,
        ),
        ElevatedButton(
          onPressed: () {
            showOrdersDialog(context);
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff9dceff),
                  Color(0xff92a3fd),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Просмотреть все заказы',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              maximumSize: Size(screenSize.width / 3, 40),
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            ),
            child: Text(
              'Выйти',
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Профиль',
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
