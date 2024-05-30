import 'package:flutter/material.dart';
import 'package:lesson47/models/todo_model.dart';

class TodoWidgets extends StatelessWidget {
  final Todo todo;
  final Function() onEdit;
  final Function() onDelete;
  final Function() onDone;

  const TodoWidgets(
      {required this.todo,
      required this.onDelete,
      required this.onEdit,
      required this.onDone,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: IconButton(
          onPressed: onDone,
          icon: todo.isDone
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.circle_outlined,
                  color: Colors.grey,
                ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          todo.time,
          style: const TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
