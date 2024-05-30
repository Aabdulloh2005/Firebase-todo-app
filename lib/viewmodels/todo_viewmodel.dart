import 'package:lesson47/models/todo_model.dart';
import 'package:lesson47/repositories/todo_repository.dart';

class TodoViewmodel {
  final todoRepository = TodoRepository();

  List<Todo> _list = [];

  Future<List<Todo>> get list async {
    _list = await todoRepository.getTodos();
    return [..._list];
  }

  void addTodo(String title, String time, bool isDone) async {
    final newTodo = await todoRepository.addTodo(title, time, isDone);

    _list.add(newTodo);
  }

  void editTodo(String title, String time, bool isDone, String id) {
    todoRepository.editTodo(title, time, isDone, id);
    final index = _list.indexWhere(
      (todo) {
        return todo.id == id;
      },
    );

    _list[index].title = title;
    _list[index].time = time;
    _list[index].isDone = isDone;
  }

  Future<void> deleteTodo(String id) async {
    await todoRepository.deleteTodo(id);
    _list.removeWhere(
      (element) {
        return element.id == id;
      },
    );
  }

  void onDone(String id, bool isDone) {
    todoRepository.onDone(id, isDone);

    final index = _list.indexWhere(
      (element) {
        return element.id == id;
      },
    );

    _list[index].isDone = !_list[index].isDone;
  }
}
