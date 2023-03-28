import 'package:flutter/foundation.dart';
import 'package:flutter_todo_list/entities/tag.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

const String TAGS_BOX_NAME = 'tags';

class TagsService {
  late final Box<Tag> tagsBox = _tagsBox;

  TagsService._();

  static TagsService get instance => TagsService._();

  ValueListenable<Box<Tag>> get listenable => tagsBox.listenable();
  Box<Tag> get _tagsBox => Hive.box(TAGS_BOX_NAME);

  Future<void> init() async {
      Hive.registerAdapter(TagAdapter());
      await Hive.openBox<Tag>(TAGS_BOX_NAME);
  }

  Future<void> changeTag(String newName, Tag tag) async {
      tag.name = newName;
      await tag.save();
  }

  Future<void> deleteTag(int index) async {
    tagsBox.deleteAt(index);
  }

  Future<int> addTag(String value) {
    return tagsBox.add(Tag(value));
  }

  List<Tag> getTags() {
    return tagsBox.values.toList();
  }


  Future<void> dispose() async {
    await Hive.box(TAGS_BOX_NAME).compact();
    await Hive.box(TAGS_BOX_NAME).close();
  }
}