import 'package:appwrite_flutter_notes/screens/Auth/LoginPage.dart';
import 'package:appwrite_flutter_notes/screens/CompletedTodosPage.dart';
import 'package:appwrite_flutter_notes/screens/CreateTodoPage.dart';
import 'package:flutter/material.dart';

import '../apis/APIs.dart';
import '../models/todo.dart';
import 'UnfinishedTodosPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<TodoModel> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: FutureBuilder(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.adjust_outlined, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Unfinished Tasks")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.done, color: Colors.green,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Completed Tasks")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline, color: Colors.redAccent,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete All Task")
                  ],
                ),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 4,
                // row with two children
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.redAccent,),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Logout")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 60),
            elevation: 2,
            onSelected: (value) async{
              // if else if ladder
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UnfinishedTodos(),
                  ),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompletedTodos(),
                  ),
                );
              } else if (value == 3) {
                await APIs.instance.deleteAllTodo(data);
                setState(() {
                  data  = [];
                });
              } else if (value == 4) {
                APIs.instance.logout();
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Logged Out')));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: APIs.instance.getTodos(),
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
              data = snapshot.data as List<TodoModel>;
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Checkbox(
                        value: data[index].isDone ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            data[index].isDone = value;
                          });
                          APIs.instance.updateTodo(data[index]);
                        },
                      ),
                      title: Text(
                        data[index].title!,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      subtitle: Text(
                        data[index].description!,
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          TodoModel deleteModel = data[index];
                          setState(() {
                            data.remove(deleteModel);
                          });
                          APIs.instance.deleteTodo(deleteModel);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[400],
                        ),
                      ),
                    );
                  });
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CreateToDoPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
