import 'package:flutter/material.dart';
import 'package:utilities_app/Constants.dart';
import 'package:utilities_app/HomePage.dart';
import 'package:utilities_app/currencyPage.dart';
import 'package:utilities_app/weatherScreen.dart';

Widget drawer (context) {
  return Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                accountName: Text(
                  "Yusuf Kolayo",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("yusufkolayor@gmail.com"),
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' Countries '),
              onTap: () {
                Navigator.pop(context);
                 Navigator.pushNamed(context, MyHomePage.routeName);
              },
            ),
           
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Currency '),
              onTap: () { 
                Navigator.pop(context);
                Navigator.pushNamed(context, CurrencyPage.routeName);
              },
            ),

             ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Weather '),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, WeatherScreen.routeName);
              },
            ),
            
          ],
        ),
      );
}