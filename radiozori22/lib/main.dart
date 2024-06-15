import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'AppModule.dart';
import 'AppWidget.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}