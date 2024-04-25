import 'package:flutter/material.dart';
import 'package:utilities_app/Constants.dart';
import 'package:utilities_app/drawer.dart';



class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});
  static String routeName = 'Currency-Converter';

  final String title = 'Currency Converter';

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}





class _CurrencyPageState extends State<CurrencyPage> {
 
 

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
        drawer: drawer(context),  
        body:  const Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
               children: [
                 Align(
                  alignment: Alignment.center,
                  child: Text('Currency Converter')
                )
               ],
            ),
          ),
        ),
      )
    );
  }
}
