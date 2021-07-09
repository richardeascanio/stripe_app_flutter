import 'package:flutter/material.dart';

import 'package:stripe_app/pages/home_page.dart';
import 'package:stripe_app/pages/pay_complete_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stripe App',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'pay_complete': (_) => PayCompletePage(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xff284879),
        scaffoldBackgroundColor: Color(0xff21232A)
      ),
    );
  }
}