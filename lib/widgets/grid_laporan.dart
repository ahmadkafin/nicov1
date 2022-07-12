import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:nicov1/helper/string_titlecase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../configs/connection_api.dart';
import '../models/laporan.dart';
import '../providers/auth.dart';
import '../providers/data_laporan.dart';

class GridLaporan extends StatefulWidget {
  GridLaporan(
      {Key? key,
      required this.area,
      required this.laporan,
      required this.dataGet})
      : super(key: key);
  final String? area;
  final Future<List<Laporan>> laporan;
  Future<List<Laporan>>? dataGet;

  @override
  State<GridLaporan> createState() => _GridLaporanState();
}

class _GridLaporanState extends State<GridLaporan> {
  bool isYes = false;
  bool downloading = false;
  var progress = "";
  var _onPressed;

  Future<void> download(
      String nameFile, String tokenParam, String tableName, String area) async {
    Dio dio = Dio();
    var checkPermissionFolder = await Permission.storage.status;
    if (checkPermissionFolder.isGranted) {
      String location = "";
      final month = DateTime.now().month.toString();
      final year = DateTime.now().year.toString();
      if (Platform.isAndroid) {
        location = "/nico/$year/$month/$area";
      } else {
        location = (await getApplicationDocumentsDirectory()).path;
      }

      try {
        Directory? downloadsDirectory =
            await DownloadsPath.downloadsDirectory();
        String fullPath = downloadsDirectory!.path + location;
        String token = tokenParam;
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final data = {
          'tableName': tableName,
          'area': area,
          'bulan': month,
          'year': year,
          'token': ConnectionApi.tokenStatic()
        };

        String url = "";
        Response response;
        response = await dio.post(
          ConnectionApi.baseUrl("LaporanTeknik/downloadFileLt"),
          data: data,
          options: Options(headers: headers),
        );
        url = response.data.toString();
        await dio.download(
          url,
          '$fullPath/$nameFile.pdf',
          onReceiveProgress: (receivedBytes, totalBytes) {
            setState(
              () {
                downloading = true;
                progress =
                    "${((receivedBytes / totalBytes) * 100).toStringAsFixed(0)}%";
              },
            );
          },
        );
      } catch (error) {
        print(error);
        throw (error);
      }
      setState(
        () {
          downloading = false;
          progress = "download complete";
        },
      );
    } else {
      setState(
        () {
          progress = "permission denied";
          _onPressed = () {};
        },
      );
    }
  }

  final snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final state = Provider.of<DataLaporan>(context);
    final appState = Provider.of<DataLaporan>(context).dataLaporan;
    final name = Provider.of<Auth>(context).name;
    final token = Provider.of<Auth>(context).token;
    final ar = Provider.of<Auth>(context).area;

    return state.isFetching
        ? Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: const CircularProgressIndicator(),
          )
        : downloading
            ? Container(
                alignment: Alignment.center,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Downloading File: $progress",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 80.0,
                      backgroundColor: Colors.black,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat("MMMM", "id_ID")
                                      .format(DateTime.now())
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                  ),
                                ),
                                const Text(" "),
                                Text(
                                  DateFormat("yyyy", "id_ID")
                                      .format(DateTime.now())
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "$name - ${widget.area}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    AnimationLimiter(
                      child: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisExtent:
                              deviceSize.width > 600 ? 100.0 : 120.0,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: deviceSize.width > 600 ? 2.0 : 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: appState.length,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  curve: Curves.easeOut,
                                  child: GestureDetector(
                                    onLongPress: () {
                                      final month =
                                          DateTime.now().month.toString();
                                      final year =
                                          DateTime.now().year.toString();
                                      String nameFile =
                                          '${removeLt(appState[index].Table_name).toTitleCase()}-$month-$year';
                                      String tableName =
                                          removeLt(appState[index].Table_name);
                                      dialogShow(context, tableName, nameFile,
                                          appState[index].Area, token!);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: appState[index].Status == "1"
                                          ? Colors.grey
                                          : ar == ""
                                              ? Colors.blue
                                              : Colors.blue,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sheet.${index + 1}'.toTitleCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 7,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  appState[index].Table_name ==
                                                          "lt_pls"
                                                      ? "Patroli Survey Kebocoran"
                                                      : removeLt(
                                                              (appState[index]
                                                                  .Table_name))
                                                          .toTitleCase(),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  appState[index].Status == "1"
                                                      ? "Approved"
                                                      : ar == ""
                                                          ? ""
                                                          : "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: appState.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  void nulls(BuildContext context) {}

  String removeLt(String tableName) {
    String tblName;
    if (tableName.contains("lt")) {
      tblName = tableName.replaceAll("lt_", "");
      return tblName;
    }
    return tableName;
  }

  Future<dynamic> dialogShow(BuildContext context, String tableName,
      String nameFile, String area, String tokenparam) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Apakah anda akan mengunduh file Laporan Teknik : $nameFile - area ${widget.area}?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Tidak",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              isYes = false;
              Navigator.of(ctx).pop(true);
            },
          ),
          TextButton(
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await scaffoldMessage(
                  context, area, "Anda telah mengunduh $tableName area ");
              try {
                await download(nameFile, tokenparam, tableName, widget.area!);
                Navigator.of(ctx).pop(true);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                throw (error);
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> scaffoldMessage(
      BuildContext context, String area, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        duration: const Duration(
          seconds: 15,
        ),
        content: Text(
          "$message ${widget.area} \n Anda bisa membukanya di folder /Downloads/nico/",
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
