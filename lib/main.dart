import 'package:appwrite_flutter_notes/screens/HomePage.dart';
import 'package:flutter/material.dart';

import 'package:appwrite/appwrite.dart';

Client client = Client();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /// Use http://10.0.2.2/v1 for if running on emulator
  client.setEndpoint('http://10.0.2.2/v1').setProject('64318d9edb39c0906a32').setSelfSigned(status: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appwrite Flutter Notes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}