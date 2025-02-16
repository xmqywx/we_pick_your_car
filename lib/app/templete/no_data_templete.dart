
import 'package:flutter/material.dart';

class EmptyStatus extends StatefulWidget {
  String title;
  EmptyStatus({super.key, required this.title});

  @override
  State<EmptyStatus> createState() => _EmptyStatusState();
}

class _EmptyStatusState extends State<EmptyStatus> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: Column(children: [
          Image.asset(
            "assets/images/noData.png",
            width: double.infinity,
            height: 300,
          ),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          )
        ]),
      ),
    );
  }
}
