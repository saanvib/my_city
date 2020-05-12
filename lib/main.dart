import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycity/welcome_cards.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My City',
      home: FirebaseAuth.instance.currentUser() != null
          ? HomePage(0)
          : WelcomeCards(),
    );
  }
}
