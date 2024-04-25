
// We use name route
// All our routes will be available here
import 'package:flutter/material.dart';
import 'package:utilities_app/HomePage.dart';
import 'package:utilities_app/currencyPage.dart';

final Map<String, WidgetBuilder> routes = {
  MyHomePage.routeName: (context) => const MyHomePage(),
  CurrencyPage.routeName: (context) => const CurrencyPage(),
};