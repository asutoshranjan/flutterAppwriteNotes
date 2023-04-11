import 'package:flutter/material.dart';

import '../apis/APIs.dart';
import '../models/todo.dart';


class UnfinishedTodos extends StatefulWidget {
  const UnfinishedTodos({Key? key}) : super(key: key);

  @override
  State<UnfinishedTodos> createState() => _UnfinishedTodosState();
}

class _UnfinishedTodosState extends State<UnfinishedTodos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unfinished Tasks"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: APIs.instance.getUnfinishedTodos(),
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
              final data = snapshot.data as List<TodoModel>;
              if(data.isEmpty) {
                return const Center(
                  child: Text("Nothing to show", style: TextStyle(color: Colors.black, fontSize: 17),),
                );
              } else {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.adjust_outlined, color: Colors.deepOrangeAccent,),
                        title: Text(
                          data[index].title!,
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        subtitle: Text(
                          data[index].description!,
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                      );
                    });
              }
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
