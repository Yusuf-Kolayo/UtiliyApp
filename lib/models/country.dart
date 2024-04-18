// import 'dart:developer';

class Country {

  late String name ;
  late String cca3 ;
  late String capital;
  late List <dynamic> languages;
  late String region;
  late bool landLocked;
  late String flagUrl;
  late String coatOfArmsUrl;
  late String googleMapsUrl;
  late String openStreetMapUrl;

    Country({
      required this.name   ,
      required this.cca3  ,
      required this.capital   ,
      required this.languages,
      required this.region   ,
      required this.landLocked ,
      required this.flagUrl  ,
      required this.coatOfArmsUrl ,
      required this.googleMapsUrl,
      required this.openStreetMapUrl,
    });



  // factory Country.fromJson(Map<String, dynamic> json) { 
  //   log(json.toString());

  //     return Country(
  //       name: json['name'],
  //       cca3: json['cca3'],
  //       capital: json['capital'],
  //       languages: json['languages'],
  //       region: json['region'],
  //       landLocked: json['landlocked'],
  //       flagUrl: json['flag'],
  //       coatOfArmsUrl: json['currency'],
  //       googleMapsUrl: json['ip_address'],
  //       openStreetMapUrl: json['created_at'],
  //     );
  //   }


}