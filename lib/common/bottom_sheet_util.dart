import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_todo_list/widgets/default_bottom_sheet_header.dart';

typedef BodyBuilder = SliverChildDelegate Function(BuildContext, double);

class BottomSheetUtil {
  static void showDefaultBottomSheet({required BuildContext context, required BodyBuilder bodyBuilder}) {
    showStickyFlexibleBottomSheet(
        minHeight: 0,
        maxHeight: 0.7,
        initHeight: 0.5,
        anchors: [0, 0.5, 0.7],
        headerHeight: 50,
        isSafeArea: true,
        context: context,
        headerBuilder: (context, _) => const DefaultBottomSheetHeader(),
        bodyBuilder: bodyBuilder
    );
  }
}