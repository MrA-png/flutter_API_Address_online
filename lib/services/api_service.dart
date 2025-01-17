// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/region.dart';

class ApiService {
  static const String baseUrl =
      'https://emsifa.github.io/api-wilayah-indonesia/api';

  Future<List<Region>> fetchProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/provinces.json'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<Region>> fetchRegencies(String provinceId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/regencies/$provinceId.json'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load regencies');
    }
  }

  Future<List<Region>> fetchDistricts(String regencyId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/districts/$regencyId.json'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }
}
