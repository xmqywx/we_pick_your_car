import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../services/screen_adapter.dart';
import '../controllers/task_info_finish_controller.dart';

class TaskInfoFinishView extends GetView<TaskInfoFinishController> {
  const TaskInfoFinishView({Key? key}) : super(key: key);
  Widget _buildSuccessSubmit() {
    return ListView(
      children: [
        SizedBox(
          height: ScreenAdapter.height(200),
        ),
        Container(
          height: ScreenAdapter.width(200),
          width: ScreenAdapter.width(200),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Icon(
            Icons.check,
            color: Colors.white,
            size: ScreenAdapter.fontSize(120),
          )),
        ),
        SizedBox(
          height: ScreenAdapter.height(100),
        ),
        const Text(
          "Successfully submitted, thanks for your work!",
          textAlign: TextAlign.center,
        ),
        TextButton(
            onPressed: () {
              Get.offAllNamed("/tabs");
            },
            child: const Text(
              "Back to home",
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () async {
              await controller.pretreatmentDetailController
                  .alertSendInvoiceDialog();
              Get.offAllNamed("/tabs");
            },
            child: const Text(
              "Send invoice",
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  Widget _buildfailedSubmit() {
    return ListView(
      children: [
        SizedBox(
          height: ScreenAdapter.height(200),
        ),
        Container(
          height: ScreenAdapter.width(200),
          width: ScreenAdapter.width(200),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Icon(
            Icons.clear,
            color: Colors.white,
            size: ScreenAdapter.fontSize(120),
          )),
        ),
        SizedBox(
          height: ScreenAdapter.height(100),
        ),
        const Text(
          "Submission failed, please try again!",
          textAlign: TextAlign.center,
        ),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Try again",
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () {
              Get.offAllNamed("/tabs");
            },
            child: const Text(
              "Back to home",
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job info'),
        centerTitle: true,
      ),
      body: Obx(() => controller.isSubmittedSuccessfully.value
          ? _buildSuccessSubmit()
          : _buildfailedSubmit()),
    );
  }
}
