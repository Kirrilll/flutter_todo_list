import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/app.dart';
import 'package:flutter_todo_list/services/tags_service.dart';
import 'package:flutter_todo_list/services/tasks_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await TaskService.instance.init();
  await TagsService.instance.init();
  runApp(const MyApp());
}

