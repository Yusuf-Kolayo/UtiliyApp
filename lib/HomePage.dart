import 'package:flutter/material.dart';
import 'package:utilities_app/Api/CountriesApi.dart';
import 'package:utilities_app/Constants.dart';
import 'dart:developer';






class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}






class _MyHomePageState extends State<MyHomePage> {
   List <dynamic> countries = [];


  @override
  Widget build(BuildContext context) {
    
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                      var response = await CountriesApi().fetchCountries();
                      if (response['status']=='success') {

                         
  
                         setState(() {
                            countries = response['data']; 
                            countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));
                            log(countries.toString());
                         });

                  
                      } else {
                          log('something went wrong ...');
                      }
                  }, 
                  style:  ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue.shade400),
                    shape: const MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero))
                  ),
                  child: const Text('Fetch Countries', style: TextStyle(color: Colors.white))
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: countries.length,
                    itemBuilder:(context, index) {
                        return ListTile(
                           leading: const Icon(Icons.list),
                            trailing: Text(
                              countries[index]['cca3'],
                              style: const TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            title: Text(countries[index]['name']['common'])
                        );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
