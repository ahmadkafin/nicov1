import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nicov1/providers/auth.dart';
import 'package:nicov1/screens/login_screen.dart';
import 'package:nicov1/screens/main_screen.dart';
import 'package:nicov1/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/data_area.dart';
import 'providers/data_laporan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await initializeDateFormatting('id_ID', null).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, DataLaporan>(
          create: (_) => DataLaporan('', []),
          update: (ctx, auth, previousMain) => DataLaporan(
            auth.token,
            previousMain == null ? [] : previousMain.dataLaporan,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, DataArea>(
          create: (_) => DataArea('', []),
          update: (ctx, auth, previousMain) => DataArea(
            auth.token,
            previousMain == null ? [] : previousMain.dataArea,
          ),
        ),
      ],
      builder: (ctx, child) => Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: "Nico",
          home: auth.isAuth
              ? const MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : snapshot.connectionState == ConnectionState.active
                            ? const SplashScreen()
                            : snapshot.connectionState == ConnectionState.done
                                ? LoginScreen()
                                : const SplashScreen();
                  },
                ),
          routes: {
            MainScreen.routeName: (context) => const MainScreen(),
          },
        ),
      ),
    );
  }
}
