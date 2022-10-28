import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/screens/notification/notification_screen.dart';
import '../../view/screens/wallet/zopay/history/history_screen.dart';
import '../../view/screens/wallet/zopay/home/home_screen.dart';

class MenuController extends GetxController implements GetxService{
  int _currentTab = 0;
  int get currentTab => _currentTab;
  final List<Widget> screen = [
    HomeScreen(),
    HistoryScreen(),
    NotificationScreen(),
    // ProfileScreen()
  ];
  Widget _currentScreen = HomeScreen();
  Widget get currentScreen => _currentScreen;

  resetNavBar(){
    _currentScreen = HomeScreen();
    _currentTab = 0;
  }

  selectHomePage() {
    _currentScreen = HomeScreen();
    _currentTab = 0;
     update();
  }

  selectHistoryPage() {
    _currentScreen = HistoryScreen();
    _currentTab = 1;
    update();
  }

  selectNotificationPage() {
    _currentScreen = NotificationScreen();
    _currentTab = 2;
    update();
  }

  // selectProfilePage() {
  //   _currentScreen = ProfileScreen();
  //   _currentTab = 3;
  //   update();
  // }
}
