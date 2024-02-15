import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/todo.dart';

class TodoDatabase extends ChangeNotifier {
  static late Isar isar;

  //initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoSchema],
      directory: dir.path,
    );
  }

  // list of notes
  final List<Todo> currentTodos = [];

  // CREATE
  Future<void> addTodo(String newTask) async {
    final newTodo = Todo()..task = newTask;
    await isar.writeTxn(() => isar.todos.put(newTodo));
    await fetchTodos();
  }

  // READ
  Future<void> fetchTodos() async {
    List<Todo> fetchedTodos = await isar.todos.where().findAll();
    currentTodos.clear();
    currentTodos.addAll(fetchedTodos);
    notifyListeners();
  }

  // UPDATE
  Future<void> updateTodo(int id, String updatedTask) async {
    final todoToBeUpdated = await isar.todos.get(id);
    if (todoToBeUpdated != null) {
      todoToBeUpdated.task = updatedTask;
      await isar.writeTxn(() => isar.todos.put(todoToBeUpdated));
      await fetchTodos();
    }
  }

  //DELETE
  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => isar.todos.delete(id));
    await fetchTodos();
  }

  // TOGGLE
  Future<void> toggleTodoStatus(int id, bool isCompleted) async {
    final todoToBeUpdated = await isar.todos.get(id);
    if (todoToBeUpdated != null) {
      todoToBeUpdated.isCompleted = !isCompleted;
      await isar.writeTxn(() => isar.todos.put(todoToBeUpdated));
      await fetchTodos();
    }
  }
}
