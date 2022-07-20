import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../providers/auth.dart';

class Disclaimer extends StatefulWidget {
  Disclaimer({Key? key}) : super(key: key);
  @override
  State<Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  bool _isAccept = false;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: ContentDisclaimer())),
            Container(
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                      primarySwatch: Colors.blue,
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                      value: _isAccept,
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        print(value);
                        setState(
                          () {
                            _isAccept = !_isAccept;
                          },
                        );
                      },
                    ),
                  ),
                  const Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async => {
                    await auth.logout().then(
                          (value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyApp(),
                            ),
                          ),
                        )
                  },
                  child: const Text(
                    "Decline",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Visibility(
                  visible: _isAccept,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async => {
                      await Provider.of<Auth>(context, listen: false)
                          .disclaimerOff()
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column ContentDisclaimer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Bahasa",
          style: TextStyle(
            fontSize: 38,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        Text(
          "Persyaratan Penggunaan",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        Text(
          "PT Perusahaan Gas Negara Tbk (“PGN”) adalah pemilik dan operator Aplikasi NICO.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "Informasi yang terdapat di dalam Aplikasi NICO telah dipersiapkan dengan sebaik mungkin serta dari sumber terpercaya dan bertanggung jawab, yang terus menerus diperbaharui dan dikembangkan sesuai dengan keadaan sebenarnya. Tujuan dari informasi ini sebagai referensi atas aset operasi yang dikelola atau dioperasikan oleh PGN Group, beserta utilitas lain di sekitar aset tersebut.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "Mengacu pada PO Standar Keamanan Informasi (O- 027/0.36), PO Pengelolaan Aset Informasi (O-013/0.36), PO Pengamanan TIK (O-008/0.36), PO Pengelolan Media Penyimpanan Informasi (O-15/0.36), ND Penyampaian Data Korporat (009900.ND,/HK/PDO/2020), Seluruh informasi yang terdapat dalam Aplikasi NICO ini bersifat rahasia; hanya pengguna yang diberikan kewenangan yang dapat menggunakan Aplikasi NICO. Dilarang untuk menyingkap, menyimpan, mendistribusikan atau menggunakan informasi yang diperoleh dari Aplikasi NICO untuk kepentingan komersial dan/atau kepentingan lain apa pun selain untuk kepentingan PGN tanpa persetujuan tertulis dari PGN dan wajib mencantumkan keterangan NICO sebagai sumber dan/atau referensi atas informasi tersebut.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "PGN tidak menjamin keakuratan atau kelengkapan informasi yang disediakan dalam Aplikasi NICO, dan PGN tidak bertanggung jawab dalam keadaan apapun atas segala kerugian atau kerusakan yang mungkin timbul baik secara langsung maupun tidak langsung akibat dari penggunaan ataupun sehubungan dengan penggunaan Aplikasi NICO.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "Apabila terdapat pertanyaan tentang keakuratan data dari Aplikasi NICO dan ketentuan penggunaan Aplikasi NICO ini, dapat menghubungi PGN Operation and Maintenance Management, Infrastructure Maintenance Management, Information Management.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "English",
          style: TextStyle(
            fontSize: 38,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        Text(
          "Terms of Use",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        Text(
          "PT Perusahaan Gas Negara Tbk (“PGN”) is the owner and operator of the NICO Application.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "The information contained in the NICO Application has been prepared responsibly based on available data sources and is being continuously updated and developed in line with actual conditions. Its purpose is to be a reference the operating assets that are managed or operated by the PGN Group, along with other utilities around such assets.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "Refer to PO Standar Keamanan Informasi (O-027/0.36), PO Pengelolaan Aset Informasi (O-013/0.36), PO Pengamanan TIK (O-008/0.36), PO Pengelolan Media Penyimpanan Informasi (O-15/0.36), ND Penyampaian Data Korporat (009900.ND,/HK/PDO/2020), Any and all information contained in the NICO Application are strictly confidential; only authorized users can access the NICO Application. It is prohibited to disclose, store, distribute or use any information obtained from the NICO Application for commercial purposes and/or any other purposes other than in furtherance of the interests of PGN without the prior written consent of PGN and NICO Application must be disclosed and referred to as the source of the information.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "PGN makes no representation or warranty on the accuracy or completeness of the information provided in the NICO Application, and PGN will not be liable under any circumstances for any loss or damage which may arise directly or indirectly as a result of or in or connection with the use of the NICO Application.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        Text(
          "Should you have any questions on the accuracy of the data from the NICO Application and these terms of use of the NICO Application, please contact PGN Operation and Maintenance Management, Infrastructure Maintenance Management, Information Management.\n",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
