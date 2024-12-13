import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../../../color/colors.dart';
import '../../../text/paragraph.dart';
import '../../../services/screen_adapter.dart';

import '../controllers/dismantlers_controller.dart';
import 'package:car_wrecker/app/widget/card_container.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DismantlersView extends GetView<DismantlersController> {
  const DismantlersView({Key? key}) : super(key: key);
  Widget _buildInitialScanPrompt() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ScreenAdapter.width(20),
        horizontal: ScreenAdapter.width(40),
      ),
      padding: EdgeInsets.all(ScreenAdapter.width(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenAdapter.width(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: ScreenAdapter.width(100),
            color: Colors.blueAccent,
          ),
          SizedBox(height: ScreenAdapter.height(20)),
          Text(
            "Scan QR Code",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(50),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          Text(
            "Please click the QR code button below to start scanning. Ensure the QR code is within the frame.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(40),
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPage() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ScreenAdapter.width(20),
        horizontal: ScreenAdapter.width(40),
      ),
      padding: EdgeInsets.all(ScreenAdapter.width(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenAdapter.width(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ScreenAdapter.width(100),
            color: Colors.redAccent,
          ),
          SizedBox(height: ScreenAdapter.height(20)),
          Text(
            "Invalid QR Code",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(50),
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          Text(
            "The QR code scanned is not valid. Please try again with a valid QR code.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(40),
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: MyParagraph(
            text: controller.vehicleLabel.value == ""
                ? 'Dismantler'
                : controller.vehicleLabel.value,
            fontSize: 65,
          ),
          centerTitle: true,
          actions: [
            if (controller.vehicleUrl.value != '')
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: controller.handleReloadWebView,
              ),
            if (controller.vehicleUrl.value != '')
              IconButton(
                icon: Icon(Icons.close),
                onPressed: controller.handleClearUri,
              ),
          ],
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: controller.containerAdd,
            child: Icon(Icons.qr_code_scanner),
          ),
        ),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: controller.handleToRefresh,
              child: Column(
                children: [
                  if (controller.vehicleUrl.value.isEmpty)
                    Expanded(
                      flex: 1,
                      child: _buildInitialScanPrompt(),
                    )
                  else if (!controller.vehicleUrl.value
                      .contains('label_width_parts'))
                    Expanded(
                      flex: 1,
                      child: _buildErrorPage(),
                    )
                  else
                    Expanded(
                        flex: 1,
                        child: WebViewWidget(
                          controller: controller.webcontroller,
                          gestureRecognizers: <
                              Factory<OneSequenceGestureRecognizer>>{
                            Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer(),
                            ),
                          },
                        )),
                ],
              ),
            ),
          )
        ])));
  }
}
