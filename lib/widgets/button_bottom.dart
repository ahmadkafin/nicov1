import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nicov1/widgets/button_bottom_element.dart';

import '../models/laporan.dart';
import '../providers/data_laporan.dart';

class ButtonBottom extends StatefulWidget {
  ButtonBottom(
      {Key? key,
      required this.deviceSize,
      required this.jabatan,
      required this.area,
      this.dataGet})
      : super(key: key);
  final String? jabatan;
  final Size deviceSize;
  final String area;
  Future<List<Laporan>>? dataGet;
  @override
  State<ButtonBottom> createState() => _ButtonBottomState();
}

class _ButtonBottomState extends State<ButtonBottom> {
  @override
  Widget build(BuildContext context) {
    String _jabatan = widget.jabatan!;
    Size _deviceSize = widget.deviceSize;
    String areaparam = widget.area;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonBottomElement(
            jabatan: _jabatan,
            deviceSize: _deviceSize,
            jab: "Admin Proyek",
            keterangan: "Disiapkan",
            areaParam: areaparam,
            dataGet: widget.dataGet,
          ),
          ButtonBottomElement(
            jabatan: _jabatan,
            deviceSize: _deviceSize,
            jab: "PJ MARIO SIMAG",
            keterangan: "Diperiksa",
            areaParam: areaparam,
            dataGet: widget.dataGet,
          ),
          ButtonBottomElement(
            jabatan: _jabatan,
            deviceSize: _deviceSize,
            jab: "Operation Management",
            keterangan: "Disetujui",
            areaParam: areaparam,
            dataGet: widget.dataGet,
          ),
        ],
      ),
    );
  }
}
