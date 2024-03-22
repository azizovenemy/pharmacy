import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:pharmacyapp/controllers/home.dart";
import "package:pharmacyapp/views/widgets/drug_dialog.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => MainPage();
}

class MainPage extends State<HomePage> {
  final HomeController _controller = Get.put(HomeController());
  int? _selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: IntrinsicHeight(
        child: Column(
          children: [
            _searchModule(),
            const SizedBox(height: 25),
            _categoryModule(),
            const SizedBox(height: 25),
            _drugsModule(),
          ],
        ),
      ),
    );
  }

  Column _drugsModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Лекарства',
            style: GoogleFonts.roboto(
              color: const Color(0xff101617),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(() {
          return _controller.isLoadingDrugs.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: 450,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: _controller.drugArr.length,
                          (BuildContext context, int index) {
                            return Container(
                              height: 150,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _controller.drugArr[index].id % 2 != 0
                                    ? const Color(0xffc58bf2).withOpacity(0.3)
                                    : const Color(0xff92a3fd).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //image
                                  Text(
                                    _controller.drugArr[index].title,
                                    style: GoogleFonts.roboto(
                                      color: const Color(0xff101617),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _controller.drugArr[index].price.toString(),
                                    style: GoogleFonts.roboto(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDrugDialog(
                                          context, _controller.drugArr[index]);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
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
                                        constraints: const BoxConstraints(
                                            minWidth: 120, minHeight: 20),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Просмотреть',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ],
    );
  }

  Column _categoryModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Категории',
            style: GoogleFonts.roboto(
              color: const Color(0xff101617),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    itemCount: _controller.categoryArr.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedCategoryIndex == index;
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                            _controller.getDrugsByCategory(
                                _controller.categoryArr[index].id);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.blue
                              : _controller.categoryArr[index].id % 2 != 0
                                  ? const Color.fromARGB(255, 144, 0, 255)
                                      .withOpacity(0.2)
                                  : const Color.fromARGB(255, 0, 42, 255)
                                      .withOpacity(0.2),
                        ),
                        child: Text(
                          _controller.categoryArr[index].title,
                          style: GoogleFonts.roboto(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_selectedCategoryIndex != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.getAllDrugs();
                        setState(() => _selectedCategoryIndex = null);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Сбросить выбор',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ))
      ],
    );
  }

  Container _searchModule() {
    return Container(
      margin: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff101617).withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: TextField(
        onChanged: (value) {
          if (value != '') {
            _controller.getDrugsByText(value);
          } else {
            _controller.getDrugsByText("|");
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Найти лекарства",
          hintStyle: GoogleFonts.roboto(
            color: const Color(0xff101617).withOpacity(0.3),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Основная',
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
