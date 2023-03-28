import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../common/toast_helper.dart';
import '../common/validation_helper.dart';
import '../entities/tag.dart';

class TagForm extends StatefulWidget {
  const TagForm({
    Key? key,
    this.initialTag,
    this.onDelete,
    required this.onSubmit,

  }) : super(key: key);

  final Future<void> Function()? onDelete;
  final Future<String?> Function(String value) onSubmit;
  final Tag? initialTag;

  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {

  late final TextEditingController _tagController = TextEditingController(text: widget.initialTag?.name ?? '');
  final _formKey = GlobalKey<FormState>();

  bool get isDeletable => widget.onDelete != null;

  _onSaveClick() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_tagController.value.text).then((value) {
        if(value == null) {
          _tagController.clear();
          Navigator.of(context).pop();
          ToastHelper.showToast(context: context, label: 'Тэг создан');
        }
        else {
          ToastHelper.showToast(context: context, label: value, isError: true);
        }
      },
          onError: (o) => ToastHelper.showToast(
              context: context, label: 'Не удалось создать тэг', isError: true)
      );
    }
  }

  _onDeleteClick() {
    if(isDeletable) {
      (widget.onDelete ?? () => Future.value())();
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tagController,
              validator: ValidationHelper.requiredValidate,
              decoration: defaultInputDecoration.copyWith(
                  label: const Text('Название тэга')),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                if(isDeletable) {
                  return ElevatedButton(
                        onPressed: _onDeleteClick,
                        child: const Text('Удалить')
                 );
                }
                return const SizedBox();
              }
            ),
            ElevatedButton(
                onPressed: _onSaveClick,
                child: const Text('Сохранить')
            )
          ],
        ),
      ),
    );
  }
}
