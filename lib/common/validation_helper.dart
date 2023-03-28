import 'package:flutter_todo_list/entities/tag.dart';

typedef ValidationFunc = String? Function(String?);

const emptyFieldValueError = 'Поле не может быть пустым';
const nonIdentityValueError = 'Значения не могут повторяться';

class ValidationHelper {
  static String? requiredValidate(String? value) {
    if(value != null && value.isEmpty)  return emptyFieldValueError;
    return null;
  }

  static ValidationFunc buildIdentityTagsValidate(List<Tag> tags) => (String? value) {
    final name = (value ?? '').trim();
    if(tags.any((tag) => tag.name == name)) return nonIdentityValueError;
    return null;
  };
}