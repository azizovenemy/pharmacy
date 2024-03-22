import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:pharmacyapp/controllers/authentication.dart";
import "package:pharmacyapp/controllers/cart.dart";
import "package:pharmacyapp/controllers/home.dart";
import "package:pharmacyapp/controllers/profile.dart";
import "package:pharmacyapp/models/cart_model.dart";
import "package:pharmacyapp/models/drug_model.dart";
import "package:pharmacyapp/views/widgets/drug_dialog.dart";

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AuthenticationController _authController =
      Get.put(AuthenticationController());
  final ProfileController _userController = Get.put(ProfileController());
  final HomeController _drugController = Get.put(HomeController());
  final CartController _controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _controller.getCarts();
    return Scaffold(
      appBar: appBar(),
      body: Obx(() {
        final user = _userController.userModel.value;
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _authController.hasAuthorized.value
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemCount: _controller.cartArr.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final CartModel cart = _controller.cartArr[index];
                        final DrugModel drug =
                            _drugController.getDrugById(cart.drugId);

                        return ListTile(
                          title: GestureDetector(
                            onTap: () {
                              showDrugDialog(context, drug);
                            },
                            child: Text(drug.title),
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${drug.price} x ${cart.quantity}'),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(
                                '${drug.price * cart.quantity}P',
                                style: GoogleFonts.roboto(
                                  color: const Color.fromARGB(255, 122, 24, 24)
                                      .withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _controller.updateQuantity(
                                      id: cart.id, amount: 1);
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Text(cart.quantity.toString()),
                              IconButton(
                                onPressed: () {
                                  if (cart.quantity > 1) {
                                    _controller.updateQuantity(
                                        id: cart.id, amount: -1);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller.deleteCart(id: cart.id);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Стоимость: ${_controller.calculateCartCost()}      - ${user.personalDiscount}%',
                          style: GoogleFonts.roboto(
                            color: const Color(0xff101617).withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Итог: ${_controller.calculateFinalCost(user.personalDiscount)}',
                          style: GoogleFonts.roboto(
                            color: const Color(0xff101617).withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.createOrder();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        minimumSize: Size(screenSize.width, 60),
                      ),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
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
                            'Оформить заказ',
                            style: GoogleFonts.roboto(
                              color: const Color(0xff101617).withOpacity(0.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Корзина',
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
