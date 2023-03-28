import 'package:flutter/material.dart';

class DefaultBottomSheetHeader extends StatelessWidget {
  const DefaultBottomSheetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        height: 5,
        width: 70,
      ),
    );
  }
}
