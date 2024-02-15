import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final String task;
  final bool isCompleted;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final dynamic Function(bool?)? onTogglePressed;
  const TodoTile(
      {super.key,
      required this.task,
      required this.isCompleted,
      required this.onEditPressed,
      required this.onDeletePressed,
      required this.onTogglePressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: isCompleted, onChanged: onTogglePressed),
      title: Text(
        task,
        style: TextStyle(
            decoration:
                isCompleted ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
