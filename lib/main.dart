import 'package:flutter/material.dart';
import 'package:sqlite/src/controlles/sqlite_controller.dart';
import 'package:sqlite/src/pages/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserPage(),
    );
  }
}
