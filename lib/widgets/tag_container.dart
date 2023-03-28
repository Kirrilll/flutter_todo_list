import 'package:flutter/material.dart';
import 'package:flutter_todo_list/widgets/default_empty_widget.dart';
import 'package:flutter_todo_list/widgets/tag.dart';

import '../entities/tag.dart';

class TagsContainer extends StatelessWidget {
  const TagsContainer(
      {Key? key, this.onDeleteTag, this.onTagTap, required this.tags})
      : super(key: key);

  final void Function(Tag tag)? onDeleteTag;
  final void Function(Tag tag)? onTagTap;
  final List<Tag> tags;

  _buildEventCallback(void Function(Tag tag)? callback, int index) {
    if(callback == null) return null;
    return () => (callback ?? () {})(tags[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (tags.isEmpty) return const DefaultEmptyWidget();
      return GridView.custom(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 2),
        childrenDelegate: SliverChildBuilderDelegate(
            (_, index) => TagView(
                  onDelete: _buildEventCallback(onDeleteTag, index),
                  tag: tags[index],
                  onTagTap: _buildEventCallback(onTagTap, index),
                ),
            childCount: tags.length),
      );
    });
  }
}
