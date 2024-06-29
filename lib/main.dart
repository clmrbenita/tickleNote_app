import 'package:ambw_uas_c14210125/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:ambw_uas_c14210125/notepage.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  await Hive.openBox('setting');
  await Hive.openBox<Map>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,  // Menyembunyikan label debug
      home: Login(),
    );
  }
}
