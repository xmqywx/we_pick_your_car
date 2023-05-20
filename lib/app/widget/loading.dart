import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenAdapter.height(1000),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
