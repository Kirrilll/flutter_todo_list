import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 0)
class Tag extends HiveObject{
  @HiveField(0)
  String name;

  Tag(this.name);
}