import 'package:flutter/material.dart';
import 'ps_list_page.dart';
import 'booking_page.dart';
import 'food_menu_page.dart';
import 'payment_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'shift_keeper_list_page.dart';
import '../widgets/custom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PSListPage(),
      BookingPage(),
      FoodMenuPage(),
      PaymentPage(),
      HistoryPage(),
      ProfilePage(),
      ShiftKeeperListPage(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
