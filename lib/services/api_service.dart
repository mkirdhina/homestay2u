import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/homestay.dart';

class ApiService {
  Future<List<Homestay>> loadHomestays({
    String search = '',
    String state = 'All',
    String district = '',
  }) async {
    final queryParams = <String, String>{};

    if (search.isNotEmpty) {
      queryParams['search'] = search;
      queryParams['limit'] = '20';
    }

    if (state != 'All') {
      queryParams['state'] = state;
    }

    if (district.isNotEmpty) {
      queryParams['district'] = district;
    }

    final uri = Uri.http(
      'slum78.myddns.me',
      '/homestay2u/api/homestays',
      queryParams.isEmpty ? null : queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to load data from server.');
    }

    final jsonData = jsonDecode(response.body);

    List dataList = [];

    if (jsonData is List) {
      dataList = jsonData;
    } else if (jsonData is Map && jsonData['data'] is List) {
      dataList = jsonData['data'];
    } else if (jsonData is Map && jsonData['homestays'] is List) {
      dataList = jsonData['homestays'];
    } else if (jsonData is Map && jsonData['results'] is List) {
      dataList = jsonData['results'];
    }

    return dataList.map((item) => Homestay.fromJson(item)).toList();
  }
}