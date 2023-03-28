
import 'package:flutter_todo_list/entities/tag.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  String title;

  @HiveField(1)
  String message;

  @HiveField(2)
  DateTime createdDate;

  @HiveField(3)
  HiveList<Tag> tags;

  Task.name(this.title, this.message, this.createdDate, this.tags);

  Task(this.title, this.message, this.createdDate, this.tags);
}