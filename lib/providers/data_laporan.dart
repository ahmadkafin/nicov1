import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nicov1/configs/connection_api.dart';
import 'package:nicov1/helper/http_post.dart';
import 'package:nicov1/models/laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLaporan with ChangeNotifier {
  List<Laporan> _data = [];

  final String? token;
  bool isFetching = false;
  DataLaporan(this.token, this._data);
  List<Laporan> get dataLaporan => [..._data];

  Uri url() {
    return Uri.parse(ConnectionApi.baseUrl('laporanteknik'));
  }

  Future<List<Laporan>> gets(String param) async {
    return await get(param);
  }

  Future<List<Laporan>> get(String areaParam) async {
    try {
      isFetching = true;
      final dataPref = await SharedPreferences.getInstance();
      final extractedData = json.decode(dataPref.getString('userData') ?? "")
          as Map<String?, dynamic>;

      final email = extractedData['area'].toString() != ""
          ? extractedData['email'].toString()
          : null;
      final month = DateTime.now().month.toString();
      final year = DateTime.now().year.toString();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final body = json.encode({
        "tableName": "lt_status_approve",
        "email": email,
        "area": areaParam,
        "bulan": month,
        "tahun": year
      });
      final res = await http.post(url(), headers: headers, body: body);
      if (res.statusCode == 200) {
        final jsons = json.decode(res.body).cast<Map<String, dynamic>>();
        extractedData['area'].toString() != ""
            ? null
            : jsons.sort(
                (a, b) =>
                    (int.parse(a["nomor_urut_table"].toString())).compareTo(
                  (int.parse(b["nomor_urut_table"].toString())),
                ),
              );

        _data = jsons.map<Laporan>((json) => Laporan.fromJson(json)).toList();
        isFetching = false;
        notifyListeners();
        return _data;
      } else {
        throw res.statusCode;
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<void> update(String areas) async {
    final urlString = url();
    final prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData') ?? "") as Map<String?, dynamic>;
    final email = extractedData['email'].toString();
    final area = areas;
    final month = DateTime.now().month.toString();
    final year = DateTime.now().year.toString();

    final headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.put(
      urlString,
      body: json.encode(
        {
          "email": email,
          "bulan": month,
          "area": area,
          "tahun": year,
        },
      ),
      headers: headers,
    );
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
