import 'package:flutter/material.dart';
import 'package:natanjir_mobile/screens/product_details_screen.dart';
import 'package:natanjir_mobile/screens/product_list_screen.dart';
import 'package:natanjir_mobile/screens/user_list_screen.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductListScreen(),
    const UserListScreen(),
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
        items: const [
          BottomNavigationBarItem(
            label: 'Početna ',
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Narudžbe',
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Korpa',
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Obavijesti',
            icon: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 0, 83, 86),
            label: 'Favoriti',
            icon: Icon(
              Icons.favorite,
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
