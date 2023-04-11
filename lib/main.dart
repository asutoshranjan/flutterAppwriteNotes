import 'package:appwrite_flutter_notes/screens/HomePage.dart';
import 'package:appwrite_flutter_notes/screens/LoadingScreen.dart';
import 'package:appwrite_flutter_notes/utils/Credentials.dart';
import 'package:flutter/material.dart';

import 'package:appwrite/appwrite.dart';

Client client = Client();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /// Use http://10.0.2.2/v1 for if running on emulator
  client.setEndpoint(Credentials.APIEndpoint).setProject(Credentials.ProjectID).setSelfSigned(status: true);
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
      home: const LoadingScreen(),
    );
  }
}
