import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';




class WeatherApi {
      WeatherApi();   

      final String baseUrl = 'https://api.openweathermap.org/data/2.5';      // Replace with your API base URL
      final String appID   = '4a78cff4f339fd9d603d6b0ee559e353';
  

    Future <dynamic> handleRequest({required String url, required Map<String, dynamic> body}) async {
       
        // Check for internet connectivity
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection
          return {'count': 0, 'status': 'failed', 'comment': 'No internet connection detected on this device, please turn on your data/internet service', 'data': {}};
        }

        dynamic response; 

        try {
          
              response = await http.get(Uri.parse(url));
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

 


      Future<Map<String, dynamic>>  fetchWeatherData({required String cityName}) async {
           String endpoint = '/weather?q=$cityName&appid=$appID';
           String url = baseUrl+endpoint;
           var response = await handleRequest(url: url, body: {});
           return response;
      } 

}