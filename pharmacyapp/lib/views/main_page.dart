import "package:flutter/material.dart";
import "package:pharmacyapp/views/nav_views/cart_page.dart";
import "package:pharmacyapp/views/nav_views/profile_page.dart";
import "package:pharmacyapp/views/nav_views/home_page.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  List pages = const [
    HomePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navBar(),
      body: pages[selectedIndex],
    );
  }

  Container navBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 25,
          offset: const Offset(8, 20),
        ),
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: navBarList(),
      ),
    );
  }

  BottomNavigationBar navBarList() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: (index) => {
        setState(() {
          selectedIndex = index;
        }),
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'cart'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'profile'),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
