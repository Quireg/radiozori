import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'flutter_radio_player_plugin.dart';
import 'player_controls/side_drawer.dart';
import 'test_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => FlutterRadioPlayer()..initPlayer()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (context, args) => const SideDrawer(),
        ),
        ChildRoute("/donate",
            child: (context, args) => const TestPage(),
            transition: TransitionType.downToUp,
        ),
      ];
}
