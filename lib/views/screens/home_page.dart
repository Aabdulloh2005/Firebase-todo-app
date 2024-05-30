import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesson47/models/todo_model.dart';
import 'package:lesson47/viewmodels/todo_viewmodel.dart';
import 'package:lesson47/views/widgets/add_dialog.dart';
import 'package:lesson47/views/widgets/todo_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoViewModel = TodoViewmodel();

  void _addTask() async {
    final data = await showDialog(
      context: context,
      builder: (context) {
        return const AddDialog();
      },
    );
    if (data != null) {
      todoViewModel.addTodo(
        data["title"],
        data["time"],
        data["isDone"],
      );
    }
    setState(() {});
  }

  void _onEdit(Todo todo) async {
    final data = await showDialog(
      context: context,
      builder: (context) {
        return AddDialog(
          todo: todo,
        );
      },
    );
    if (data != null) {
      todoViewModel.editTodo(
        data["title"],
        data["time"],
        data["isDone"],
        todo.id,
      );
    }
    setState(() {});
  }

  void _onDone(Todo todo) async {
    todoViewModel.onDone(todo.id, todo.isDone);
    setState(() {});
  }

  void _onDelete(Todo todo) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Are you sure"),
          content: Text("You will delete the plan: ${todo.title}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (response) {
      await todoViewModel.deleteTodo(todo.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text(
          "Todo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: FutureBuilder(
        future: todoViewModel.list,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapShot.hasError) {
            return const Center(
              child: Text("Apida error bor"),
            );
          }
          if (!snapShot.hasData) {
            return const Center(
              child: Text("Api null kevotti"),
            );
          }

          final tasks = snapShot.data;

          return tasks == null || tasks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: tasks.length,
                  itemBuilder: (context, i) {
                    final todo = tasks[i];
                    return TodoWidgets(
                        todo: todo,
                        onDelete: () {
                          _onDelete(todo);
                        },
                        onDone: () {
                          _onDone(
                            todo,
                          );
                        },
                        onEdit: () {
                          _onEdit(todo);
                        });
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: _addTask,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
