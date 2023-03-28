import 'package:flutter/material.dart';

class DefaultEmptyWidget extends StatelessWidget {
  const DefaultEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Пусто'),
    );
  }
}
