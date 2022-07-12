import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nicov1/models/area.dart';
import 'package:nicov1/models/laporan.dart';
import 'package:nicov1/providers/data_area.dart';
import 'package:nicov1/providers/data_laporan.dart';
import 'package:nicov1/widgets/button_bottom.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth.dart';
import 'grid_laporan.dart';

class TabData extends StatefulWidget {
  TabData(
      {Key? key,
      required this.area,
      required this.areaParam,
      required this.laporan,
      required this.jabatan,
      required this.dataGet})
      : super(key: key);
  final List<Area> area;
  final String areaParam;
  final Future<List<Laporan>> laporan;
  final String? jabatan;
  Future<List<Laporan>>? dataGet;

  @override
  State<TabData> createState() => _TabDataState();
}

class _TabDataState extends State<TabData> {
  String? areaParamChild;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    areaParamChild = widget.areaParam;
  }

  @override
  Widget build(BuildContext context) {
    List<Area> areaData = widget.area;
    Future<List<Laporan>> _laporan = widget.laporan;
    String _jabatan = widget.jabatan!;
    final state = Provider.of<DataLaporan>(context);

    final deviceSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: widget.area.length,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: PreferredSize(
            preferredSize: const Size(0, 30),
            child: TabBar(
              isScrollable: true,
              padding: const EdgeInsets.only(
                bottom: 0.0,
                top: 0.0,
              ),
              indicatorColor: Colors.white,
              onTap: (index) {
                setState(
                  () {
                    areaParamChild =
                        widget.area.elementAt(index).DataArea.toString();
                  },
                );
              },
              tabs: areaData
                  .map(
                    (e) => Tab(
                      text: e.DataArea.toString(),
                    ),
                  )
                  .toList(),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       widget.dataGet =
              //           Provider.of<DataLaporan>(context, listen: false)
              //               .get(areaParamChild!);
              //     });
              //   },
              //   child: Text("refresh"),
              // ),
              IconButton(
                onPressed: () async {
                  var auth = Provider.of<Auth>(context, listen: false);
                  await auth.logout().then(
                        ((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(),
                              ),
                            )),
                      );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20.0,
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: areaData
              .map(
                (e) => GridLaporan(
                  laporan: _laporan,
                  area: e.DataArea.toString(),
                  dataGet: widget.dataGet,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: Container(
          height: 60.0,
          color: Colors.black,
          child: ButtonBottom(
            deviceSize: deviceSize,
            jabatan: _jabatan,
            area: areaParamChild!,
            dataGet: widget.dataGet,
          ),
        ),
      ),
    );
  }
}
