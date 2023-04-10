import 'package:appwrite_flutter_notes/screens/Auth/LoginPage.dart';
import 'package:flutter/material.dart';

import '../apis/APIs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        actions: [
          IconButton(
            onPressed: () {
              APIs.instance.logout();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Logged Out')));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: APIs.account.get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data ;
              return Center(
                child: Column(
                  children: [
                    Text(
                      snapshot.data!.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      snapshot.data!.email,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
