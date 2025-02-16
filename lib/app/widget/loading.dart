import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ScreenAdapter.height(1000),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
