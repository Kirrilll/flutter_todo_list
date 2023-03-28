import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_todo_list/entities/task.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../entities/tag.dart';

const String TASK_BOX_NAME = 'task';

class TaskService {

  late final Box<Task> taskBox = _taskBox;

  TaskService._();
  static TaskService get instance => TaskService._();
  Box<Task> get _taskBox => Hive.box<Task>(TASK_BOX_NAME);

  ValueListenable<Box<Task>> getListenableValue() {
    return taskBox.listenable();
  }

  Future<void> init() async {
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(TASK_BOX_NAME);
  }

  Future<void> update(Task task, String title, String description, List<Tag> tags) async {
    task.message = description;
    task.title = title;
    task.tags
      ..clear()
      ..addAll(tags);
    await task.save();
  }

  Future<void> add(Task task) async => await taskBox.add(task);
  Future<void> remove(int index) async => await taskBox.deleteAt(index);

  Future<void> dispose() async {
    await taskBox.compact();
    await taskBox.close();
  }

  List<Task> getTask() {
    return taskBox.values.toList();
  }
}