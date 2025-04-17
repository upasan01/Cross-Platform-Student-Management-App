import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocationService {
  static Future<List<Map<String, dynamic>>> _loadStateDistrictData() async {
    final String jsonString = await rootBundle.loadString('assets/indian_states_districts.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.cast<Map<String, dynamic>>();
  }

  static Future<List<String>> loadStates() async  {
    final data = await _loadStateDistrictData();
    final List<String> allStates = data.map((e) => e['state'] as String).toList();
    return allStates;
  }
  

  static Future<List<String>> updateDistricts(String selectedState) async {
    final data = await _loadStateDistrictData();
    final stateEntry = data.firstWhere((e) => e['state'] == selectedState, orElse: () => {"districts": []});
    return List<String>.from(stateEntry['districts']);
  }
}