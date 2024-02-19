import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TestData {
  final url = Uri.parse('http://192.168.43.245:8080/api');

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        return jsonResponse;
      }
    } catch (err) {
      rethrow;
    }
    return [];
  }

  Future<bool> addData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(url, body: data);
      Map value = convert.jsonDecode(response.body);
      return value['success'] as bool;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }

  Future<bool> deleteData(String id) async {
    try {
      final response = await http.delete(url, body: {'id': id});
      Map value = convert.jsonDecode(response.body);
      return value['success'] as bool;
    } catch (err) {
      return false;
    }
  }

  Future<bool> updataData(Map<String, dynamic> data) async {
    try {
      final response = await http.put(url,
          headers: {'Content-Type': 'application/JSON'}, body: data);
      Map value = convert.jsonDecode(response.body);
      return value['success'] as bool;
    } catch (err) {
      return false;
    }
  }
}
