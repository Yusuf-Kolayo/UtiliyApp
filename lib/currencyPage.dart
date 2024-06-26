import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utilities_app/Api/CurrenciesApi.dart';
import 'package:utilities_app/drawer.dart';
import 'package:utilities_app/size_config.dart';



class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});
  static String routeName = 'Currency-Converter';

  final String title = 'Currency Converter';

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}





class _CurrencyPageState extends State<CurrencyPage> {
    List <dynamic> currencies = [];
    
      var selectedFromCurrency;
      var selectedToCurrency;

      String fromAmount = '';
      String toAmount = '';

      TextEditingController fromController = TextEditingController();
      TextEditingController toController = TextEditingController();




    

  Widget currencyDropDown ({required String selectedType}) {
    return DropdownButton<String>(
                alignment: AlignmentDirectional.centerStart,
                hint: const Text('Currency'),
                value: (selectedType=='from') ? selectedFromCurrency : selectedToCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                       if (selectedType=='from') {
                          selectedFromCurrency = newValue!; 
                       } else {
                          selectedToCurrency = newValue!; 
                       }
                    }
                  );
                },
                items: currencies.map<DropdownMenuItem<String>>((currency) {
                      return DropdownMenuItem<String>(
                        value: currency[0],
                        child: Text(currency[1].length > 28 ? "${currency[1].substring(0, 28)} ..." : currency[1],),
                      );
                }).toList(),
              );
  }
 



 Column currencyPageColumn() {
     return Column(
          children: 
          [
            Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(100),
                    child: TextFormField(
                          controller: fromController,
                          keyboardType: TextInputType.number,
                          // initialValue: fromAmount,
                          onChanged: (value) {
                            fromAmount = value;
                          },
                          decoration:  InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                            contentPadding: const EdgeInsets.fromLTRB(0,0,10,3),
                            // labelText: 'Amount',
                            hintText: '0.0',
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                          ),
                    ),
                  ), 
                  Expanded( child: currencyDropDown(selectedType: 'from')),
                ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(100),
                    child: TextFormField(
                          controller: toController,
                          keyboardType: TextInputType.number,
                          // initialValue: toAmount,
                          onChanged: (value) {
                            toAmount = value;
                          },
                          decoration:  InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                            contentPadding: const EdgeInsets.fromLTRB(0,0,10,3),
                            // labelText: 'Amount',
                            hintText: '0.0',
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                          ),
                    ),
                  ),
        
                  Expanded( child: currencyDropDown(selectedType: 'to'), ),
                ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:25),
              child: TextButton(
                onPressed: () async {
                  log('From Currency: $selectedFromCurrency');
                  log('To Currency: $selectedToCurrency');
                    log('From Amount: $fromAmount');
                    log('To Amount: $toAmount');

                     final response = await  CurrenciesApi().convertCurrency(fromCurrency: selectedFromCurrency, toCurrency: selectedToCurrency, amount: fromAmount);
                     log(response.toString());
                    if (response['status']=='success') {
                       setState(() {
                         toController.text = response['data']['result'].toString();
                       });   
                    } else {
                         // ignore: use_build_context_synchronously
                         ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something went wrong, please try again', style: TextStyle(fontSize: 18)),
                                duration: Duration(seconds: 3), // Adjust the duration as needed
                                backgroundColor: Colors.black, // Customize the background color
                              ),
                            ); 
                    }
      
                }, 
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue.shade100), 
                  side: MaterialStatePropertyAll(BorderSide(color: Colors.blue.shade500)),
                ),
                child: const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 100),
                  child:  Text('Convert', style: TextStyle(fontSize: 20)),
                )
              ),
            )
          ],
     );
 }
  
 

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
        body:  SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 15, left:15, top: getProportionateScreenHeight(40)),
            child: Consumer(
               builder:(context, ref, child) {
                   if (currencies.isNotEmpty) {
                        return currencyPageColumn();
                   } else {
                       return  FutureBuilder(
                           future: CurrenciesApi().fetchCurrencies(), 
                           builder: (context, snapshot) {

                              if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
                                  return SizedBox(
                                      height: getProportionateScreenWidth(200),
                                      child: const Center(child: CircularProgressIndicator()));
                              } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                              } else if (snapshot.connectionState == ConnectionState.done) {
              
                                        final response = snapshot.data;
                                  
                                        if (response!['status']=='success') {  

                                            response['data']['result'].forEach((code, name) {
                                              currencies.add([code, name]);
                                            }); 
                                            log(currencies.toString());   
                                             return currencyPageColumn();
                                        } else {
                                            return const SizedBox(
                                                  child: Center(child: Text('Unable to loading currencies'))
                                              );
                                        }  
                                        
                              } else {
                                    return const SizedBox(
                                        child: Center(child: Text('loading currencies ...'))
                                    );
                              }

                           },
                       );
                   }
               },
            ),
          ),
        )
    );
  }
}
