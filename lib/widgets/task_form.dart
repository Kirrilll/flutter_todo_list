import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/entities/tag.dart';
import 'package:flutter_todo_list/entities/task.dart';
import 'package:flutter_todo_list/widgets/tag_container.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common/styles.dart';
import '../common/toast_helper.dart';
import '../common/validation_helper.dart';

enum UpdateListFieldFormMode {
  remove,
  add
}

class TaskForm extends StatefulWidget {
  const TaskForm({
    Key? key,
    this.onDelete,
    this.initialTask,
    required this.onSubmit,
    required this.tags,
    required this.createTag
  }) : super(key: key);

  final Future<void> Function()? onDelete;
  final Future<String?> Function(String title, String description, List<Tag> tags) onSubmit;
  final Task? initialTask;
  final List<Tag> tags;
  final Future<String?> Function(String tag) createTag;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
  late final _descriptionController = TextEditingController(text: widget.initialTask?.message ?? '');
  final _tagController = TextEditingController();
  late List<Tag> _tagsList = List.of(widget.initialTask?.tags ?? [], growable: true );


  bool get isDeletable => widget.onDelete != null;

  String _displayStringForOption(Tag option) => option.name;

  _onUpdateListField<T>(FormFieldState<List<T>> fieldList, T value, UpdateListFieldFormMode mode) {
    final List<T> list = List.from(_tagsList, growable: true);
    if(mode == UpdateListFieldFormMode.remove) list.remove(value);
    if(mode == UpdateListFieldFormMode.add) list.add(value);
    setState(() {
      _tagsList = List.from(list);
      // fieldList.didChange(list);
    });
  }

  _onCreateTag(String tag) {
    widget.createTag(tag).then(
        (value) {
          if(value == null) {
            ToastHelper.showToast(context: context, label: 'Тэг создан');
          } else {
            ToastHelper.showToast(context: context, label: value, isError: true);
          }
        }
    );
  }

  _buildOnDelete(BuildContext context) => () {
    if(widget.onDelete != null) {
      (widget.onDelete ?? () => Future.value())()
          .then((value) {
            Navigator.pop(context);
            ToastHelper.showToast(context: context, label: 'Задача успешно удалена');
      });
    }
  };

  _buildOnSubmit(BuildContext context) => () {
    widget.onSubmit(
      _titleController.value.text,
      _descriptionController.value.text,
      _tagsList
    ).then((value) {
      if(value == null) {
        ToastHelper.showToast(context: context, label: 'Задача успешно создана');
        Navigator.pop(context);
      }
    });
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: _buildOnSubmit(context),
                    icon: const Icon(Icons.save)
                ),
                Builder(
                    builder: (_) => isDeletable
                        ? IconButton(
                        onPressed: _buildOnDelete(context),
                        icon: const Icon(Icons.delete_forever)
                    )
                        : const SizedBox()
                )
              ],
            ),
            TextFormField(
              controller: _titleController,
              validator: ValidationHelper.requiredValidate,
              decoration: defaultInputDecoration.copyWith(
                  label: const Text('Название тэга')),
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: ValidationHelper.requiredValidate,
              decoration: defaultInputDecoration.copyWith(
                  label: const Text('Описание')
              ),
              controller: _descriptionController,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            FormField(
                validator: ValidationHelper.requiredValidate,
                builder: (FormFieldState<List<Tag>> field) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Autocomplete<Tag>(
                          displayStringForOption: _displayStringForOption,
                          onSelected: (tag) => _onUpdateListField(field, tag, UpdateListFieldFormMode.add),
                          optionsBuilder: (tagEditingValue) {
                            if(tagEditingValue.text.isEmpty) return List.empty();
                            return widget.tags.where((tag) => tag.name.contains(tagEditingValue.text));
                          },
                          // optionsMaxHeight: 100,
                          optionsViewBuilder: (_, onSelect, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                child: SizedBox(
                                  height: 200.0,
                                  child: Builder(
                                    builder: (context) {
                                      final optionsList = options.toList();
                                      // if(optionsList.isEmpty) {
                                      //   return Center(
                                      //     child: ElevatedButton(
                                      //       onPressed: _onCreateTag(_tagController.value.text),
                                      //       child: const Text('Добавить'),
                                      //     ),
                                      //   );
                                      // }
                                      return ListView.builder(
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: options.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final option = optionsList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              onSelect(option);
                                            },
                                            child: ListTile(
                                              title: Text(option.name),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ),
                            );
                          },
                          fieldViewBuilder: (_, tagController, focus, ___) => (
                            TextField(
                              controller: tagController,
                              focusNode: focus,
                              decoration: defaultInputDecoration.copyWith(
                                  label: const Text('Название тэга')
                              ),
                            )
                          ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 50),
                          child:  TagsContainer(
                              tags: _tagsList,
                              onDeleteTag: (tag) => _onUpdateListField(field, tag, UpdateListFieldFormMode.remove)
                          ),
                      )
                    ],
                  );
                },
            )
            // Builder(
            //     builder: (context) {
            //       if(isDeletable) {
            //         return ElevatedButton(
            //             onPressed: _onDeleteClick,
            //             child: const Text('Удалить')
            //         );
            //       }
            //       return const SizedBox();
            //     }
            // ),
            // ElevatedButton(
            //     onPressed: _onSaveClick,
            //     child: const Text('Сохранить')
            // )
          ],
        ),
      ),
    );;
  }
}
