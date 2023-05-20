import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Checkbox(activeColor: Colors.red, value: true, onChanged: (v) {}),
          const Text("Read and agree"),
          const Text(
            " User Agreement",
            style: TextStyle(color: Colors.red),
          ),
          const Text(
            " Privacy Agreement",
            style: TextStyle(color: Colors.red),
          ),
          // const Text("xxxxxxxxxxxxxx", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
