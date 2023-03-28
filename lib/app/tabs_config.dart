import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/tag_page.dart';
import 'package:flutter_todo_list/pages/task_page.dart';

enum Tabs {
  tasks,
  tags
}

extension TabsExtentension on Tabs {
  Widget getPage() {
    switch(this){
      case Tabs.tasks:
        return TaskPage();
      case Tabs.tags:
        return TagPage();
    }
  }

  Widget getIcon(){
    switch(this) {
      case Tabs.tasks:
        return const Icon(Icons.task);
      case Tabs.tags:
        return const Icon(Icons.tag);
    }
  }
}