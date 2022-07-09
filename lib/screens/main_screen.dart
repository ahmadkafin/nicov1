import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nicov1/providers/data_area.dart';
import 'package:nicov1/widgets/disclaimer.dart';
import 'package:nicov1/widgets/tab_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/laporan.dart';
import '../providers/auth.dart';
import '../providers/data_laporan.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? areaParam;
  late Future<List<Laporan>> _data;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    Provider.of<DataArea>(context, listen: false).get();
    areaParam = Provider.of<Auth>(context, listen: false).area == ""
        ? "Medan"
        : Provider.of<Auth>(context, listen: false).area;
    token = Provider.of<Auth>(context, listen: false).token;
    _data = Provider.of<DataLaporan>(context, listen: false).get(areaParam!);
  }

  Future<void> checkPermission() async {
    var checkPermissionFolder = await Permission.storage.status;
    if (checkPermissionFolder.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    var areas = Provider.of<DataArea>(context).dataArea;
    String? jabatan = Provider.of<Auth>(context, listen: false).jabatan;
    bool disclaimer = Provider.of<Auth>(context).disclaimer ?? false;

    return disclaimer
        ? Disclaimer()
        : FutureBuilder<List<Laporan>>(
            future: _data,
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                case ConnectionState.waiting:
                  print("waiting");
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                case ConnectionState.active:
                  print("active");
                  return Text("active");
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text("error");
                  } else {
                    return TabData(
                      area: areas,
                      areaParam: areaParam!,
                      laporan: _data,
                      jabatan: jabatan,
                      dataGet: _data,
                    );
                  }
              }
            },
          );
  }
}
