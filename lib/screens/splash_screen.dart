import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:nicov1/main.dart';
import 'package:nicov1/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 20));
    print('go!');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return EasySplashScreen(
      logoSize: deviceSize.width > 600 ? 150 : 250,
      logo: Image.asset(
        'images/nicoLogo.png',
      ),
      backgroundColor: Colors.black,
      showLoader: true,
      loaderColor: Colors.white,
      loadingText: const Text(
        "Loading",
        style: TextStyle(color: Colors.white),
      ),
      durationInSeconds: 20,
    );
  }
}
