import 'dart:ui';

import 'package:flutter/material.dart';

class EmptyStatus extends StatefulWidget {
  const EmptyStatus({super.key});

  @override
  State<EmptyStatus> createState() => _EmptyStatusState();
}

class _EmptyStatusState extends State<EmptyStatus> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 400,
        child: Column(
          children: [
            Image.network("https://img0.baidu.com/it/u=3894700078,749163488&fm=253&fmt=auto&app=138&f=PNG?w=500&h=375",width: double.infinity,height: 300,),
            Text("No task currently",style: TextStyle(fontSize: 16),)
          ]
        ),
      ),
    );
  }
}