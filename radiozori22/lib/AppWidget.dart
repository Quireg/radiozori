import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Radiozori',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Colors.black, background: Colors.white), fontFamily: 'MazzardH',),
      darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark(
              primary: Colors.white, background: Colors.black), fontFamily: 'MazzardH',),
      themeMode: ThemeMode.system,

      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
