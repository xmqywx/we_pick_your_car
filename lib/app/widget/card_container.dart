import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final List<Widget> children;
  MainAxisAlignment mainAlign;
  CrossAxisAlignment crossAlign;
  EdgeInsetsGeometry padding;
  CardContainer(
      {super.key,
      required this.children,
      this.mainAlign = MainAxisAlignment.center,
      this.crossAlign = CrossAxisAlignment.center,
      this.padding = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: mainAlign,
          crossAxisAlignment: crossAlign,
          children: children,
        )
    );
  }
}

class MyCardContainer extends StatelessWidget {
  final List<Widget> children;
  MainAxisAlignment mainAlign;
  CrossAxisAlignment crossAlign;
  EdgeInsetsGeometry padding;
  MyCardContainer(
      {super.key,
      required this.children,
      this.mainAlign = MainAxisAlignment.center,
      this.crossAlign = CrossAxisAlignment.center,
      this.padding = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Container(
        child:     Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 2,
      child: Container(
        padding: padding,
        child: Column(
          mainAxisAlignment: mainAlign,
          crossAxisAlignment: crossAlign,
          children: children,
        ),
      ),
    )
    );
  }
}


