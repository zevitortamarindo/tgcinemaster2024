import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinemaster_app/homePage.dart';
import 'package:cinemaster_app/watchlist.dart';
import 'package:cinemaster_app/profile_screen.dart';
import 'package:cinemaster_app/wheel_screen.dart';
import 'package:cinemaster_app/models/user_provider.dart';

class NavBarController with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  List<Widget> pages(UserProvider userProvider) {
    final currentUserId = userProvider.userData?.userId ?? '';

    return [
      Home(),
      Watchlist(),
      WheelScreen(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''), // Passando userId para WheelScreen
      ProfileScreen(),
    ];
  }
}
