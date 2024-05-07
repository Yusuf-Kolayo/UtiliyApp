import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';




class CurrenciesApi {
  
      final String baseUrl = 'https://currency-converter-pro1.p.rapidapi.com';      // Replace with your API base URL
      late final Map<String, String> headers;


      CurrenciesApi() {
          _initializeHeaders(); 
      } 

      void _initializeHeaders() {
        headers = {
            'X-RapidAPI-Key': 'a715ee6403msh4e07a2273aec7d1p12afbbjsn0c64162e49a6',
            'X-RapidAPI-Host': 'currency-converter-pro1.p.rapidapi.com'
        };
      }

    

    

 

    Future <dynamic> handleRequest({required String method, required String url, required Map<String, dynamic> body}) async {
       
       
        // Check for internet connectivity
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection
          return {'count': 0, 'status': 'failed', 'comment': 'No internet connection detected on this device, please turn on your data/internet service', 'data': {}};
        }


        dynamic response;


        try {
          if (method=='post') {
              response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
          } else {
              response = await http.get(Uri.parse(url), headers: headers);
          }
          // log(response.body.toString());
          // log(response.statusCode.toString());


          if (response.statusCode == 201 || response.statusCode == 200) {
            // Parse the server response
            final responseData = jsonDecode(response.body);
            // log(responseData.runtimeType.toString());
           
              return { 'status':'success', 'comment':'data fetched successfully', 'data': responseData};
         
          } else {
            return { 'status': 'failed', 'comment': 'Something went wrong, please try again : "${response.statusCode}"', 'data': {}};
          }
        } catch (error) {
          log(error.toString());
          return { 'status': 'failed', 'comment': 'Error: $error', 'data': {}};
        }
      }






      Future<Map<String, dynamic>>  fetchCurrencies() async {
           String endpoint = '/currencies';
           String url = baseUrl+endpoint;
           var response = await handleRequest(method: 'get',url: url, body: {});
           return response;
      }





      Future<Map<String, dynamic>>  convertCurrency({required String fromCurrency, required String toCurrency, required String amount}) async {
           String endpoint = '/convert?from=$fromCurrency&to=$toCurrency&amount=$amount';
           String url = baseUrl+endpoint;
           var response = await handleRequest(method: 'get',url: url, body: {});
           return response;
      }

}