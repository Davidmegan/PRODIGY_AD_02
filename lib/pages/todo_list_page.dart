import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_database.dart';
import 'package:todo_app/models/todo_tile.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readTodos();
  }

  // CREATE
  void createTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<TodoDatabase>().addTodo(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  //READ
  void readTodos() {
    context.read<TodoDatabase>().fetchTodos();
  }

  // UPDATE
  void updateTodo(Todo todo) {
    textController.text = todo.task;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<TodoDatabase>()
                  .updateTodo(todo.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  // DELETE
  void deleteTodo(int id) {
    context.read<TodoDatabase>().deleteTodo(id);
  }

  // TOGGLE
  void toggleTodoStatus(Todo todo) {
    context.read<TodoDatabase>().toggleTodoStatus(todo.id, todo.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    // todo database
    final todoDatabase = context.watch<TodoDatabase>();
    // current todo list
    List<Todo> currentTodos = todoDatabase.currentTodos;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo list'),
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createTodo,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 0.0),
          child: ListView.builder(
              itemCount: currentTodos.length,
              itemBuilder: (context, index) {
                final todo = currentTodos[index];
                return TodoTile(
                  task: todo.task,
                  isCompleted: todo.isCompleted,
                  onEditPressed: () => updateTodo(todo),
                  onDeletePressed: () => deleteTodo(todo.id),
                  onTogglePressed: (value) => toggleTodoStatus(todo),
                );
              }),
        ));
  }
}
