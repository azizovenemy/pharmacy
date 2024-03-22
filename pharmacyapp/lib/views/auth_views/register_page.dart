import "package:flutter/material.dart";
import "package:pharmacyapp/controllers/authentication.dart";
import "package:pharmacyapp/views/auth_views/login_page.dart";
import "../widgets/input_widget.dart";
import "package:google_fonts/google_fonts.dart";
import "package:get/get.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputWidget(
                hintText: 'Имя',
                controller: _firstNameController,
                obscureText: false,
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Фамилия',
                controller: _lastNameController,
                obscureText: false,
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Логин',
                controller: _loginController,
                obscureText: false,
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Пароль',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                onPressed: () async {
                  await _authenticationController.register(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    login: _loginController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                },
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Зарегистрироваться',
                          selectionColor: Colors.white,
                          style: GoogleFonts.roboto(fontSize: size * 0.040),
                        );
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
                child: Text(
                  'Войти',
                  style: GoogleFonts.roboto(
                    fontSize: size * 0.040,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Регистрация',
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
