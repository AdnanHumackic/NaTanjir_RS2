import 'package:flutter/material.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/screens/korpa_screen.dart';
import 'package:natanjir_mobile/screens/narudzbe_list_screen.dart';
import 'package:natanjir_mobile/screens/obavijesti_list_screen.dart';
import 'package:natanjir_mobile/screens/product_details_screen.dart';
import 'package:natanjir_mobile/screens/product_list_screen.dart';
import 'package:natanjir_mobile/screens/restoran_favorit_list_screen.dart';
import 'package:natanjir_mobile/screens/restoran_list_screen.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    RestoranListScreen(),
    NarudzbeListScreen(),
    KorpaScreen(),
    ObavijestListScreen(),
    RestoranFavoritListScreen()
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 0, 83, 86),
        items: [
          BottomNavigationBarItem(
            label: 'Početna ',
            activeIcon: Icon(Icons.home_sharp, color: Colors.white),
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Narudžbe',
            activeIcon: Icon(Icons.shopping_bag_sharp),
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Korpa',
            activeIcon: Icon(Icons.shopping_cart_sharp, color: Colors.white),
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Obavijesti',
            activeIcon: Icon(Icons.chat_rounded, color: Colors.white),
            icon: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 0, 83, 86),
            label: 'Favoriti',
            activeIcon: Icon(Icons.favorite, color: Colors.white),
            icon: Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    ));
  }
}
