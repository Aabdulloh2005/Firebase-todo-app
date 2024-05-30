import 'dart:convert';

import 'package:lesson47/models/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoHttp {
  Future<List<Todo>> getUrl() async {
    Uri url = Uri.parse(
        "https://todo-app-3fb9c-default-rtdb.firebaseio.com/tasks.json");

    final response = await http.get(url);
    Map<String, dynamic>? data = jsonDecode(response.body);

    List<Todo> loadedTodos = [];

    if (data != null) {
      data.forEach(
        (key, value) {
          value["id"] = key;
          loadedTodos.add(Todo.fromJson(value));
        },
      );
    }

    return loadedTodos;
  }

  Future<Todo> addTodo(String title, String time, bool isDone) async {
    Uri url = Uri.parse(
        "https://todo-app-3fb9c-default-rtdb.firebaseio.com/tasks.json");

    Map<String, dynamic> todoData = {
      "title": title,
      "time": time,
      "isDone": isDone,
    };

    final response = await http.post(url, body: jsonEncode(todoData));

    final data = jsonDecode(response.body);
    todoData["id"] = data["name"];
    Todo newTodo = Todo.fromJson(todoData);
    return newTodo;
  }

  Future<void> editTodo(
    String title,
    String time,
    bool isDone,
    String id,
  ) async {
    Uri url = Uri.parse(
        "https://todo-app-3fb9c-default-rtdb.firebaseio.com/tasks/$id.json");

    Map<String, dynamic> todoData = {
      "title": title,
      "time": time,
      "isDone": isDone,
    };

    final response = await http.patch(
      url,
      body: jsonEncode(todoData),
    );
  }

  Future<void> deleteTodo(String id) async {
    Uri url = Uri.parse(
        "https://todo-app-3fb9c-default-rtdb.firebaseio.com/tasks/$id.json");

    await http.delete(url);
  }

  Future<void> onDone(String id, bool isDone) async {
    Uri url = Uri.parse(
        "https://todo-app-3fb9c-default-rtdb.firebaseio.com/tasks/$id.json");

    Map<String, dynamic> todoData = {
      "isDone": !isDone,
    };

    await http.patch(
      url,
      body: jsonEncode(todoData),
    );
  }
}
