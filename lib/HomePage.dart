import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utilities_app/Api/CountriesApi.dart';
import 'package:utilities_app/Constants.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:developer';

import 'package:utilities_app/models/country.dart';
import 'package:utilities_app/size_config.dart';






class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}






class _MyHomePageState extends State<MyHomePage> {
   List <dynamic> countries = [];
   Country country = Country(name: '',capital: '', cca3: '', languages: [],region: '', landLocked: false, flagUrl: '', coatOfArmsUrl: '', googleMapsUrl: '', openStreetMapUrl: '');



  Widget countriesContainer () {
    return SizedBox(
        height: 500,
        child: ListView.builder(
          itemCount: countries.length,
          itemBuilder:(context, index) {
              return GestureDetector(
                onTap: () {
                    // log(countries[index].toString());
                    setState(() {
                      country.name = countries[index]['name']['common'];
                      country.cca3 = countries[index]['cca3'];
                      country.capital = countries[index]['capital'][0];
                      country.flagUrl = countries[index]['flags']['svg'];
                      country.languages = countries[index]['languages'].values.toList();
                       
                    });
                },
                child: ListTile(
                  leading: const Icon(Icons.list),
                    trailing: Text(  
                      countries[index]['cca3'],
                      style: const TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(countries[index]['name']['common'])
                ),
              );
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Align(
          alignment: Alignment.center,
          child: Text(widget.title)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Setting Icon',
            onPressed: () {},
          )
    ],
      ),
       drawer: Drawer(
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
              },
            ),
           
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Currency '),
              onTap: () {
                Navigator.pop(context);
              },
            ),

             ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Weather '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            
          ],
        ),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: (country.name.isNotEmpty),
                  child: Column(
                    children: [
                       Text(
                        country.name,
                        style: const TextStyle(fontSize: 30), 
                      ),
                       Padding(
                         padding: const EdgeInsets.only(bottom:15, top: 5),
                         child: SvgPicture.network(
                            country.flagUrl,
                            width: getProportionateScreenHeight(300),
                                             ),
                       )
                    ],
                  )
                ),
                Consumer(
                  builder:(context, ref, child) {
                      if (countries.isNotEmpty) {
                            return  countriesContainer();
                      } else {
                          return  FutureBuilder(
                            future: CountriesApi().fetchCountries(), 
                            builder:(context, snapshot) {
                            
                                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
                                      return SizedBox(
                                          height: getProportionateScreenWidth(200),
                                          child: const Center(child: CircularProgressIndicator()));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.connectionState == ConnectionState.done) {

                                            final response = snapshot.data;
                                            if (response!['status']=='success') {

                                                
                                                countries = response['data']; 
                                                countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
                                                // log(countries.toString());
                                            

                                                return countriesContainer();

                                            } else {
                                                return const SizedBox(
                                                      child: Center(child: Text('Unable to loading countries data ...'))
                                                  );
                                            } 
                                    } else {
                                        return const SizedBox(
                                            child: Center(child: Text('loading countries data, please wait ...'))
                                        );
                                    }
                            
                              },
                          );
                      }
                     
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
