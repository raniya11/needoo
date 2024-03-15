import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/accoutns/profile_page.dart';
import 'package:food_delivery_app/features/home/screens/home_page.dart';
import 'package:food_delivery_app/features/notification/notification_page.dart';
import 'package:food_delivery_app/features/search/search.dart';
import 'package:provider/provider.dart';

import '../services/bottom_nav_service.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;

  List<Widget> _list = [
    HomePage(),
    NotificationPage(),
    SearchPage(),
    AccountsPage(),
  ];
  void onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Consumer<BottomNavBarProvider>(
          builder: (context, navProvider, child) {
            return BottomNavigationBar(
              currentIndex: navProvider.currentIndex,
              onTap: (index) {
                navProvider.updateIndex(index);
              },
              backgroundColor: Colors.black38,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.home_outlined,),
                    label: "Home"), //0
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_outlined,),
                    label: "Notification"), //1
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"), //2
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: "Accounts") //3
              ],

              unselectedItemColor: Colors.black38,
              selectedItemColor: Colors.green,
            );
          },
        ),

        body: _list.elementAt(
            Provider.of<BottomNavBarProvider>(context).currentIndex));
  }
}
