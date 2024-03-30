import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:pharmacyapp/controllers/order.dart";
import "package:google_fonts/google_fonts.dart";

void showOrdersDialog(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  final OrderController controller = Get.put(OrderController());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: screenSize.height * 0.8,
              width: screenSize.width,
              child: ListView.builder(
                itemCount: controller.orderArr.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        controller.orderArr[index].id.toString(),
                        style: GoogleFonts.roboto(
                          color: const Color(0x00000000).withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        'Цена: ${controller.orderArr[index].price} \nДата: ${controller.orderArr[index].createdAt.toString()}',
                        style: GoogleFonts.roboto(
                          color: const Color(0x00000000).withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Подробнее',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 122, 24, 24)
                                .withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
    },
    isScrollControlled: true,
  );
}
