import 'package:flutter/material.dart';
import 'package:flutter_todo_list/common/bottom_sheet_util.dart';
import 'package:flutter_todo_list/common/validation_helper.dart';
import 'package:flutter_todo_list/entities/tag.dart';
import 'package:flutter_todo_list/services/tags_service.dart';
import 'package:flutter_todo_list/services/tasks_service.dart';
import 'package:flutter_todo_list/widgets/tag_form.dart';
import 'package:flutter_todo_list/widgets/task_container.dart';

import '../widgets/default_loading_widget.dart';
import '../widgets/tag_container.dart';

class TagPage extends StatelessWidget {
  TagPage({Key? key}) : super(key: key);

  final TagsService _tagService = TagsService.instance;
  final TaskService _taskService = TaskService.instance;

  Future<String?> onEditTag(String newName, Tag tag) async {
    final tags = _tagService.getTags();
    final validationRes = ValidationHelper.buildIdentityTagsValidate(tags)(newName);
    if(validationRes == null) {
      tag.name = newName;
      await tag.save();
    }
    return validationRes;
  }

  Future<void> onDeleteTag(int index) => _tagService.deleteTag(index);

  Future<String?> onCreateTag(String tag) async {
    final tags = _tagService.getTags();
    final validationRes = ValidationHelper.buildIdentityTagsValidate(tags)(tag);
    if(validationRes == null) await _tagService.addTag(tag);
    return validationRes;
  }

  Future<void> Function() _buildOnDelete(BuildContext context, Tag tag) => () {
    final taskWhitTag = _taskService.getTask().where((task) => task.tags.contains(tag)).toList();
    if(taskWhitTag.isEmpty) {
      onDeleteTag(_tagService.getTags().indexOf(tag));
    }
    else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            scrollable: true,
            title: const Text('Тэги содержатся в задачах:'),
            alignment: Alignment.center,
            content: SizedBox(
              height: 200,
              width: 200,
              child: TaskContainer(
                tasks: taskWhitTag,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть')
              ),
              ElevatedButton(
                  onPressed: ()  {
                    onDeleteTag(_tagService.getTags().indexOf(tag));
                    Navigator.pop(context);
                  },
                  child: const Text('Хорошо')
              ),
            ],
          )
      );
    }
    return Future.value();
  };

  _buildOnPlusClick(BuildContext context) => () {
        BottomSheetUtil.showDefaultBottomSheet(
            context: context,
            bodyBuilder: (_, __) => SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => TagForm(onSubmit: onCreateTag)));
  };

  _buildOnTagTap(BuildContext context) => (Tag tag ) {
    BottomSheetUtil.showDefaultBottomSheet(
        context: context,
        bodyBuilder: (_, __) => SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => TagForm(
                    onSubmit: (value) => onEditTag(value, tag),
                    onDelete: _buildOnDelete(context, tag),
                    initialTag: tag,
                )
        )
    );
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _tagService.listenable,
          builder: (_, tagsBox, __) {
            if (!tagsBox.isOpen) return const DefaultLoadingWidget();
            final tags = tagsBox.values.toList();
            return TagsContainer(
                tags: tags,
                onTagTap: _buildOnTagTap(context),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildOnPlusClick(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
