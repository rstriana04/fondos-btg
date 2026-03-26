import 'package:flutter/material.dart';
import 'package:fondos_btg/app.dart';
import 'package:fondos_btg/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const FondosBtgApp());
}
