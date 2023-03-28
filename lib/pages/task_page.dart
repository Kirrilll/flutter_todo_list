import 'package:flutter/material.dart';
import 'package:flutter_todo_list/common/bottom_sheet_util.dart';
import 'package:flutter_todo_list/services/tags_service.dart';
import 'package:flutter_todo_list/services/tasks_service.dart';
import 'package:flutter_todo_list/widgets/task_container.dart';
import 'package:flutter_todo_list/widgets/task_form.dart';
import 'package:hive/hive.dart';

import '../common/validation_helper.dart';
import '../entities/tag.dart';
import '../entities/task.dart';

class TaskPage extends StatelessWidget {
  TaskPage({Key? key}) : super(key: key);

  final TaskService _taskService = TaskService.instance;
  final TagsService _tagService = TagsService.instance;

  Future<String?> onCreateTag(String tag) async {
    final tags = _tagService.getTags();
    final validationRes = ValidationHelper.buildIdentityTagsValidate(tags)(tag);
    if (validationRes == null) await _tagService.addTag(tag);
    return validationRes;
  }

  Future<String?> onCreateTask(
      String title, String description, List<Tag> tags) async {
    final task = Task(title, description, DateTime.now(),
        HiveList(_tagService.tagsBox, objects: tags));
    await _taskService.add(task);
    return null;
  }

  Future<String?> onDeleteTask(int index) async {
    await _taskService.remove(index);
    return null;
  }

  Future<String?> onUpdateTask(
      Task task, String title, String description, List<Tag> tags) async {
    await _taskService.update(task, title, description, tags);
    return null;
  }

  _buildOnPlusClick(BuildContext context) => () {
        BottomSheetUtil.showDefaultBottomSheet(
            context: context,
            bodyBuilder: (_, __) => SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => TaskForm(
                      onSubmit: onCreateTask,
                      tags: _tagService.getTags(),
                      createTag: onCreateTag,
                    )));
      };

  _buildOnTaskTap(BuildContext context) => (Task task) {
        BottomSheetUtil.showDefaultBottomSheet(
            context: context,
            bodyBuilder: (_, __) => SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => TaskForm(
                      initialTask: task,
                      onDelete: () =>
                          onDeleteTask(_taskService.getTask().indexOf(task)),
                      onSubmit:
                          (String title, String description, List<Tag> tags) =>
                              onUpdateTask(task, title, description, tags),
                      tags: _tagService.getTags(),
                      createTag: onCreateTag,
                    )));
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _taskService.getListenableValue(),
          builder: (_, taskBox, __) {
            if (!taskBox.isOpen) return const Center(child: CircularProgressIndicator());
            if (taskBox.isEmpty) return const Center(child: Text('Пусто...'));
            final todos = taskBox.values.toList();
            return TaskContainer(
                tasks: todos,
                onTaskTap: _buildOnTaskTap(context),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildOnPlusClick(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
