import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:number_selector/repositories/location_interface.dart';

class LocationRepository implements ILocationRepository {
  @override
  Future<String> getCountryCode() async {
    var response = await http.get(Uri.parse('http://ip-api.com/json'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['countryCode'];
    } else {
      throw Exception('Failed to get country code');
    }
  }

  @override
  Future<String> getCountryName() async {
    var response = await http.get(Uri.parse('http://ip-api.com/json'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['country'];
    } else {
      throw Exception('Failed to get country');
    }
  }

  @override
  Future<String> getNumberCode(countryName) async {
    var response = await http
        .get(Uri.parse('https://countrycode.dev/api/countries/$countryName'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data[0]['E164'];
    } else {
      throw Exception('Failed to get country number');
    }
  }
}
