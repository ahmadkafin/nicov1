import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nicov1/configs/connection_api.dart';
import 'package:nicov1/helper/http_post.dart';
import 'package:nicov1/models/area.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataArea with ChangeNotifier {
  List<Area> _data = [];
  final String? token;

  DataArea(this.token, this._data);
  List<Area> get dataArea => [..._data];

  Uri url() {
    return Uri.parse(ConnectionApi.baseUrl("laporanteknik/dataarea"));
  }

  Future<List<Area>> get() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedData = json.decode(prefs.getString('userData') ?? "")
          as Map<String?, dynamic>;
      final email = extractedData['email'].toString();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final body = json.encode({"email": email});
      final response = await http.post(url(), headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsons = json.decode(response.body).cast<Map<String, dynamic>>();
        _data = jsons.map<Area>((json) => Area.fromJson(json)).toList();
        notifyListeners();
        return _data;
      } else {
        throw response.statusCode;
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }
}
