import 'package:lesson47/models/todo_model.dart';
import 'package:lesson47/services/todo_http.dart';

class TodoRepository {
  final todoHttp = TodoHttp();

  Future<List<Todo>> getTodos() {
    return todoHttp.getUrl();
  }

  Future<Todo> addTodo(String title, String time, bool isDone) async {
    final newProduct = await todoHttp.addTodo(title, time, isDone);

    return newProduct;
  }

  Future<void> editTodo(
      String title, String time, bool isDone, String id) async {
    await todoHttp.editTodo(title, time, isDone, id);
  }

  Future<void> deleteTodo(String id) async {
    await todoHttp.deleteTodo(id);
  }

  Future<void> onDone(String id, bool isDone) async {
    await todoHttp.onDone(id, isDone);
  }

}
