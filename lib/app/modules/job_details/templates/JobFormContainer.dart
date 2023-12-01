import 'package:flutter/material.dart';
import '../../../services/keep_alive_wrapper.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/card_container.dart';
import '../../../text/paragraph.dart';
import '../../../color/colors.dart';

class JobFormContainer extends StatelessWidget {
  final Future<void> Function() handleRefresh;
  final List<Widget> contents;
  const JobFormContainer(
      {super.key, required this.handleRefresh, required this.contents});

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
        child: Column(
      children: [
        Expanded(
          flex: 1,
          child: RefreshIndicator(
              onRefresh: handleRefresh,
              child: ListView(
                  padding: EdgeInsets.all(ScreenAdapter.width(15)),
                  children: contents)),
        )
      ],
    ));
  }
}

class CardTitle extends StatelessWidget {
  final String title;
  const CardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenAdapter.width(15),
          vertical: ScreenAdapter.width(30)),
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.divider1, width: 1))),
      child: MyParagraph(
        text: title,
        fontSize: 55,
        align: TextAlign.center,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
