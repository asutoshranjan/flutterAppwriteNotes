import 'package:appwrite_flutter_notes/screens/HomePage.dart';
import 'package:flutter/material.dart';

import '../apis/APIs.dart';

class CreateToDoPage extends StatefulWidget {
  const CreateToDoPage({Key? key}) : super(key: key);

  @override
  State<CreateToDoPage> createState() => _CreateToDoPageState();
}

class _CreateToDoPageState extends State<CreateToDoPage> {
  String title = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Create New Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: (val) {
                setState(() {
                  title = val;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (val) {
                setState(() {
                  description = val;
                });
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                await APIs.instance
                    .createTodo(title: title, description: description)
                    .then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                });
              },
              child: const Text("Create Todo"),
            ),
          ],
        ),
      ),
    );
  }
}

