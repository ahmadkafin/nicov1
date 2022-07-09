import 'package:flutter/material.dart';

class Area with ChangeNotifier {
  final String DataArea;

  Area({
    required this.DataArea,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        DataArea: json['area'].toString(),
      );
}
