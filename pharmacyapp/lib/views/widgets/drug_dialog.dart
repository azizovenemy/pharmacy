import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:pharmacyapp/controllers/cart.dart";
import "package:pharmacyapp/models/drug_model.dart";
import "package:pharmacyapp/views/widgets/raiting_widget.dart";
import "package:google_fonts/google_fonts.dart";

void showDrugDialog(BuildContext context, DrugModel drug) {
  Size screenSize = MediaQuery.of(context).size;
  final comments = 0.obs;
  final CartController controller = Get.put(CartController());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: screenSize.height * 0.8,
        width: screenSize.width,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //const SizedBox(height: 20),
            //Image.network(drug.image),
            const SizedBox(height: 20),
            Text(
              drug.title,
              style: GoogleFonts.roboto(
                color: const Color(0xff101617),
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Описание: ${drug.description}',
              style: GoogleFonts.roboto(
                color: const Color(0xff101617).withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            RatingWidget(rating: drug.rating),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Комментарии: ${comments.value}',
                style: GoogleFonts.roboto(
                  color: const Color(0xff101617),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return comments.value > 0
                  ? SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: comments.value,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Элемент $index'),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    );
            }),
            const SizedBox(height: 10),
            Text(
              'Цена: ${drug.price.toString()}',
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 241, 50, 50),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenSize.width, 50),
              ),
              onPressed: () {
                controller.addToCart(drug.id);
                Navigator.pop(context);
              },
              child: Ink(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9dceff),
                      Color(0xff92a3fd),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 120, minHeight: 20),
                  alignment: Alignment.center,
                  child: const Text(
                    'Добавить в корзину',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    isScrollControlled: true,
  );
}
