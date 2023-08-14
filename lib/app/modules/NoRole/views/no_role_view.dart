import '../../../services/screen_adapter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/no_role_controller.dart';

class NoRoleView extends GetView<NoRoleController> {
  const NoRoleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Your account identity is not \n suitable for accessing this app.',
          style: TextStyle(
              fontSize: ScreenAdapter.width(60), fontFamily: 'Roboto-Medium'),
        ),
      ),
    );
  }
}
