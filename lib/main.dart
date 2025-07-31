import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/register_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/sweets/sweet_detail_screen.dart'; // If using direct navigation


void main() {
  runApp(A2BSweetShopApp());
}

class A2BSweetShopApp extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A2B Sweets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data! ? HomeScreen() : LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        // Add more as you create new screens
      },
    );
  }
}
