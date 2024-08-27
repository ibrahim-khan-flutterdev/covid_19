import 'dart:convert';

import 'package:covid/view/services/utility.dart';
import 'package:http/http.dart' as http;

import '../../models/WorldStatesModel.dart';

class StatesServices {
  Future<WorldStatesModel> getStates() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> getCountry() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('error');
    }
  }
}
