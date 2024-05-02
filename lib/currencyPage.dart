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




    

  Widget fromCurrenciesContainer () {
    return DropdownButton<String>(
                alignment: AlignmentDirectional.centerStart,
                hint: const Text('Currency'),
                value: selectedFromCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                      selectedFromCurrency = newValue!; 
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
 




 

  Widget toCurrenciesContainer () {
    return DropdownButton<String>(
                alignment: AlignmentDirectional.centerStart,
                hint: const Text('Currency'),
                value: selectedToCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                      selectedToCurrency = newValue!; 
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
            child: Column(
               children: [


                 Row(
                    children: [
                       SizedBox(
                         width: getProportionateScreenWidth(100),
                         child: TextFormField(
                              keyboardType: TextInputType.number,
                              // initialValue: '0.0',
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
 


                       Expanded(
                         child: Consumer(
                            builder:(context, ref, child) {
                            if (currencies.isNotEmpty) {
                                  return  fromCurrenciesContainer();
                            } else {
                                return  FutureBuilder(
                                  future: CurrenciesApi().fetchCurrencies(), 
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
                                                      
                                                      // currencies = response['data']['result'].values.map((value){
                                                      //   return [value.]
                                                      // }).toList();

                                                      response['data']['result'].forEach((code, name) {
                                                        currencies.add([code, name]);
                                                      });
                                                      
                                                      log(currencies.toString());
                                                  
                                                      
                         
                                                       return  fromCurrenciesContainer();
                         
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
                      
                    ],
                 ),

                 SizedBox(height: getProportionateScreenHeight(20)),

                 Row(
                    children: [
                       SizedBox(
                         width: getProportionateScreenWidth(100),
                         child: TextFormField(
                              keyboardType: TextInputType.number,
                              // initialValue: '0.0',
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
 


                       Expanded(
                         child: Consumer(
                            builder:(context, ref, child) {
                            if (currencies.isNotEmpty) {
                                  return toCurrenciesContainer();
                            } else {
                                return  FutureBuilder(
                                  future: CurrenciesApi().fetchCurrencies(), 
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
                                                      
                                                      // currencies = response['data']['result'].values.map((value){
                                                      //   return [value.]
                                                      // }).toList();

                                                      response['data']['result'].forEach((code, name) {
                                                        currencies.add([code, name]);
                                                      });
                                                      
                                                      log(currencies.toString());
                                                  
                                                      
                         
                                                       return  toCurrenciesContainer();
                         
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
                      
                    ],
                 ),




                 Padding(
                   padding: const EdgeInsets.only(top:25),
                   child: TextButton(
                    onPressed: () {
                      log('From Currency: '+selectedFromCurrency);
                       log('To Currency: '+selectedToCurrency);
                        log('From Amount: '+fromAmount);
                         log('To Amount: '+toAmount);


                       


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
            ),
          ),
        )
    );
  }
}
