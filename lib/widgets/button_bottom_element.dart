import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/laporan.dart';
import '../providers/data_laporan.dart';

class ButtonBottomElement extends StatefulWidget {
  ButtonBottomElement(
      {Key? key,
      required this.jabatan,
      required this.deviceSize,
      required this.jab,
      required this.keterangan,
      required this.areaParam,
      required this.dataGet})
      : super(key: key);
  final String? jabatan;
  final Size deviceSize;
  final String? jab;
  final String? keterangan;
  final String? areaParam;
  Future<List<Laporan>>? dataGet;

  @override
  State<ButtonBottomElement> createState() => _ButtonBottomElementState();
}

class _ButtonBottomElementState extends State<ButtonBottomElement> {
  @override
  Widget build(BuildContext context) {
    String _jabatan = widget.jabatan!;
    Size _deviceSize = widget.deviceSize;
    String _jab = widget.jab!;
    String _keterangan = widget.keterangan!;
    String _areaParam = widget.areaParam!;
    return ElevatedButton(
      onPressed: _jabatan == _jab
          ? () {
              dialogShow(context, _areaParam);
            }
          : null,
      style: TextButton.styleFrom(
        backgroundColor: _jabatan == _jab ? Colors.amber : Colors.grey,
        padding: EdgeInsets.symmetric(
          horizontal: _deviceSize.width > 600
              ? _deviceSize.width / 10
              : _deviceSize.width / 15,
        ),
      ),
      child: Text(
        _keterangan,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<dynamic> dialogShow(BuildContext context, String areaParam) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Apakah anda akan approve laporan area $areaParam?",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: const Text(
              "Tidak",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<DataLaporan>(context, listen: false)
                    .update(areaParam)
                    .then((value) {
                  setState(
                    () {
                      widget.dataGet =
                          Provider.of<DataLaporan>(context, listen: false)
                              .get(areaParam);
                    },
                  );
                }).then(
                  (value) => scaffoldMsgr(
                    context,
                    areaParam,
                    "Terima kasih telah melakukan approve pada area ",
                  ),
                );
              } catch (error) {
                scaffoldMsgr(context, areaParam, error.toString());
              }
              Navigator.of(ctx).pop(true);
            },
            child: const Text(
              "Ya",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  void scaffoldMsgr(BuildContext context, String area, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        duration: const Duration(
          seconds: 15,
        ),
        content: Text(
          "$message $area",
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
