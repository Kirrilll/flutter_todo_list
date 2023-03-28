import 'package:flutter/material.dart';
import 'package:flutter_todo_list/entities/task.dart';
import 'package:flutter_todo_list/widgets/tag.dart';

class TaskView extends StatelessWidget {
  const TaskView({
    Key? key,
    required this.task,
    this.onTaskTap
  }) : super(key: key);

  final Task task;
  final void Function()? onTaskTap;

  String get formattedDate => task.createdDate.toString().split(' ').first;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTaskTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15)
        ),
        constraints:  const BoxConstraints(
          maxHeight: 120
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    fontSize: 22
                  ),
                ),
                Text(formattedDate)
              ],
            ),
            Text(task.message),
            Expanded(
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => TagView(tag: task.tags.elementAt(index)),
                  separatorBuilder: (_, __) => const SizedBox(height: 10, width: 10),
                  itemCount: task.tags.length
              ),
            )
          ],
        ),
      ),
    );
  }
}
