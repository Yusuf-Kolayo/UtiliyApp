import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';




class CountriesApi {
  
      final String baseUrl = 'https://restcountries.com/v3.1';      // Replace with your API base URL
      late final Map<String, String> headers;


      CountriesApi() {
          _initializeHeaders(); 
      } 

      void _initializeHeaders() {
        headers = {};
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






      Future<Map<String, dynamic>>  fetchCountries() async {
           String endpoint = '/all';
           String url = baseUrl+endpoint;
           var response = await handleRequest(method: 'get',url: url, body: {});
           return response;
      }

}