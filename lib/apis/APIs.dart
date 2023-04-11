

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/todo.dart';
import '../utils/Credentials.dart';

class APIs {
  APIs._privateConstructor();
  static final APIs _instance = APIs._privateConstructor();
  static APIs get instance => _instance;
  static final Future<SharedPreferences> _prefs =
  SharedPreferences.getInstance();

  static final account = Account(client);

  static final databases = Databases(client);

  var uuid = Uuid();


  Future<void> createTodo(
      {required String title, required String description}) async {
    try {
      await getUserID().then((userId) async {
        String docId = uuid.v1();
        TodoModel myToDo = TodoModel(
          title: title,
          description: description,
          isDone: false,
          userId: userId,
          docId: docId,
        );
        await databases.createDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.CollectionId,
          documentId: docId,
          data: myToDo.toJson(),
        );
      });
    } catch (e) {
      rethrow;
    }
  }


  Future<List<TodoModel>> getTodos() async {
    List<TodoModel> outModel = [];
    try {
      await getUserID().then((userId) async {
        models.DocumentList response = await databases.listDocuments(
            databaseId: Credentials.DatabaseId,
            collectionId: Credentials.CollectionId,
            queries: [Query.equal('userId', userId)]);
        outModel =
            response.documents.map((e) => TodoModel.fromJson(e.data)).toList();
      });
    } catch (e) {
      rethrow;
    }
    return outModel;
  }

  updateTodo(TodoModel todo) async {
    try {
      await databases.updateDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.CollectionId,
        documentId: todo.docId!,
        data: todo.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  deleteTodo(TodoModel todo) async {
    try {
      await databases.deleteDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.CollectionId,
        documentId: todo.docId!,
      );
    } catch (e) {
      rethrow;
    }
  }


  /// Delete All
  deleteAllTodo(List<TodoModel> allTodos) async {
    for (TodoModel currentTodo in allTodos) {
      try {
        await databases.deleteDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.CollectionId,
          documentId: currentTodo.docId!,
        );
      } catch (e) {
        rethrow;
      }
    }
  }



  /// Unfinished Todos
  Future<List<TodoModel>> getUnfinishedTodos() async {
    List<TodoModel> outModels = [];
    try {
      await getUserID().then((userId) async {
        models.DocumentList response = await databases.listDocuments(
            databaseId: Credentials.DatabaseId,
            collectionId: Credentials.CollectionId,
            queries: [
              Query.equal('userId', userId),
              Query.notEqual('isDone', true),
            ]);
        outModels =
            response.documents.map((e) => TodoModel.fromJson(e.data)).toList();
      });
    } catch (e) {
      rethrow;
    }
    return outModels;
  }


  /// Completed Todos
  Future<List<TodoModel>> getCompletedTodos() async {
    List<TodoModel> outModels = [];
    try {
      await getUserID().then((userId) async {
        models.DocumentList response = await databases.listDocuments(
            databaseId: Credentials.DatabaseId,
            collectionId: Credentials.CollectionId,
            queries: [
              Query.equal('userId', userId),
              Query.equal('isDone', true),
            ]);
        outModels =
            response.documents.map((e) => TodoModel.fromJson(e.data)).toList();
      });
    } catch (e) {
      rethrow;
    }
    return outModels;
  }





  Future<String?> getUserID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userId');
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', value);
  }

  Future<bool> loginEmailPassword(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    try {
      final models.Session response =
      await account.createEmailSession(email: email, password: password);
      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUpEmailPassword(
      String email, String password, String name) async {
    final SharedPreferences prefs = await _prefs;
    try {
       await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      final models.Session response = await account.createEmailSession(
        email: email,
        password: password,
      );
      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    final SharedPreferences prefs = await _prefs;
    setLoggedIn(false);
    prefs.remove('userId');
    prefs.remove('email');
    prefs.remove('password');
  }

}

