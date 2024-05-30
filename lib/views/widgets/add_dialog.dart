import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesson47/models/todo_model.dart';

class AddDialog extends StatefulWidget {
  final Todo? todo;
  const AddDialog({this.todo, super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  String? taskName;
  DateTime? taskDate;
  TimeOfDay? taskTime;
  String? date = " ";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      taskName = widget.todo!.title;
      date = widget.todo!.time;
      setState(() {});
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      taskTime ??= TimeOfDay.now();
      date =
          "${DateFormat("dd-MMMM").format(DateTime.now())} ${taskTime!.hour}:${taskTime!.minute}";

      Navigator.pop(
          context, {"isDone": false, "title": taskName, "time": date});
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.green),
          onPressed: _addTask,
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      title: widget.todo == null
          ? const Text("Add plan")
          : const Text("Edit a task"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: taskName,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.add_task),
                border: OutlineInputBorder(),
                label: Text("Task name"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter task name';
                }
                return null;
              },
              onSaved: (value) {
                taskName = value;
              },
            ),
            const SizedBox(height: 10),
            Text(date!),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue.shade400,
              ),
              onPressed: () async {
                taskDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );
                taskTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  taskTime ??= TimeOfDay.now();
                });
              },
              child: const Text(
                "Select a day",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
