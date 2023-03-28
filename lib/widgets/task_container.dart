import 'package:flutter/material.dart';

import 'package:flutter_todo_list/services/tasks_service.dart';
import 'package:flutter_todo_list/widgets/task.dart';

import '../entities/task.dart';


class TaskContainer extends StatelessWidget {
  const TaskContainer({
    Key? key,
    this.onTaskTap,
    required this.tasks
  }) : super(key: key);

  static final taskService = TaskService.instance;
  final void Function(Task task)? onTaskTap;
  final List<Task> tasks;


  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: tasks.length,
              itemBuilder: (_, index) => TaskView(
                  task: tasks[index],
                  onTaskTap: onTaskTap != null
                      ?  () => onTaskTap?.call(tasks[index])
                      : null
              ),
              separatorBuilder: (_,__) => const SizedBox(height: 10),
          );
  }
}
