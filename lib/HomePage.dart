import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utilities_app/Api/CountriesApi.dart';
import 'package:utilities_app/Constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utilities_app/drawer.dart';
import 'dart:developer';

import 'package:utilities_app/models/country.dart';
import 'package:utilities_app/size_config.dart';






class MyHomePage extends StatefulWidget {
  static String routeName = 'HomePage';

  const MyHomePage({super.key});

  final String title = 'Home Page';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}





class _MyHomePageState extends State<MyHomePage> {
   List <dynamic> countries = [];
   Country country = Country(name: '',capital: '', cca3: '', languages: [],region: '', landLocked: false, flagUrl: '', coatOfArmsUrl: '', googleMapsUrl: '', openStreetMapUrl: '');



  Widget countriesContainer () {
    return SizedBox(
        height: getProportionateScreenHeight(500),
        child: ListView.builder(
          itemCount: countries.length,
          itemBuilder:(context, index) {
              return GestureDetector(
                onTap: () {
                    log(countries[index].toString());
                    setState(() {
                      country.name = countries[index]['name']['common'];
                      country.cca3 = countries[index]['cca3'];
                      country.capital = countries[index]['capital'][0];
                      country.region = countries[index]['region'];
                      country.flagUrl = countries[index]['flags']['svg'];
                      country.languages = countries[index]['languages'].values.toList();
                       
                    });
                },
                child: ListTile(
                  leading: const Icon(Icons.list),
                  // tileColor: Colors.blue.shade50,
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
      drawer: drawer(context),
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
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           children: [
                             SizedBox(
                              width: getProportionateScreenWidth(100),
                              child: const Text('Country', style: TextStyle(fontSize: 18)),
                             ),
                             Text(
                                  country.name,
                                  style: const TextStyle(fontSize: 18), 
                              ),
                           ],
                         ),
                       ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                           children: [
                             SizedBox(
                              width: getProportionateScreenWidth(100),
                              child: const Text('Capital', style: TextStyle(fontSize: 18)),
                             ),
                             Text(
                                  country.capital,
                                  style: const TextStyle(fontSize: 18), 
                              ),
                           ],
                                                ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                           children: [
                             SizedBox(
                              width: getProportionateScreenWidth(100),
                              child: const Text('Region', style: TextStyle(fontSize: 18)),
                             ),
                             Text(
                                  country.region,
                                  style: const TextStyle(fontSize: 18), 
                              ),
                           ],
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                           children: [
                             SizedBox(
                              width: getProportionateScreenWidth(100),
                              child: const Text('Languages', style: TextStyle(fontSize: 18)),
                             ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   ...List.generate(
                                    country.languages.length, (index) {
                                       return Text(
                                        country.languages[index],
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    })
                                ],
                              )
                           ],
                                                ),
                         ),
                       Padding(
                         padding: const EdgeInsets.only(bottom:25, top: 10),
                         child: SvgPicture.network(
                            country.flagUrl,
                            width: getProportionateScreenHeight(300),
                         ),
                       )
                    ],
                  )
                ),
                const SizedBox(height: 10),
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
