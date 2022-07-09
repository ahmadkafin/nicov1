import 'dart:ffi';

import 'package:flutter/material.dart';

class Laporan with ChangeNotifier {
  final String id;
  final String Email;
  final String Table_name;
  final String Area;
  final String Bulan;
  final String Tahun;
  final String Status;

  Laporan({
    required this.id,
    required this.Email,
    required this.Table_name,
    required this.Area,
    required this.Bulan,
    required this.Tahun,
    required this.Status,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        id: json['id'].toString(),
        Email: json['email'].toString(),
        Table_name: json['module'],
        Area: json['area'].toString(),
        Bulan: json['bulan'].toString(),
        Tahun: json['tahun'].toString(),
        Status: json['isApprove'].toString(),
      );
}
