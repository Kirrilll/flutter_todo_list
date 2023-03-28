import 'package:flutter/material.dart';

import '../entities/tag.dart';

class TagView extends StatelessWidget {
  const TagView({
    Key? key,
    required this.tag,
    this.onDelete,
    this.onTagTap
  }) : super(key: key);

  final Tag tag;
  final void Function()? onTagTap;
  final void Function()? onDelete;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTagTap,
      child: Chip(
        onDeleted: onDelete,
        deleteIcon: const Icon(Icons.close),
        materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(tag.name),
      ),
    );
  }
}
