import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import '../services/https_client.dart';
import '../widget/toast.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import '../color/colors.dart';

Future<File?> saveImageToFile(Uint8List? imageBytes) async {
  if (imageBytes == null) {
    return null;
  }
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/signature.jpg';
  final imageFile = File(imagePath);
  await imageFile.writeAsBytes(imageBytes);
  return imageFile;
}

HttpsClient httpsClient = HttpsClient();

class GenerateSignature extends StatefulWidget {
  final Function changeSignature;
  GenerateSignature({Key? key, required this.changeSignature})
      : super(key: key);

  @override
  _GenerateSignatureState createState() => _GenerateSignatureState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
    //     Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _GenerateSignatureState extends State<GenerateSignature> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: AppColors.themeTextColor3,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.themeTextColor3, width: 1),
                  color: AppColors.white,
                ),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    // debugPrint(
                    //     '${sign!.points.length} points in the signature');
                  },
                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List())),
          Container(
            color: AppColors.themeTextColor3,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: AppColors.logoBgc,
                        onPressed: () async {
                          final sign = _sign.currentState;
                          final image = await sign!.getData();
                          final bytes = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          final encoded =
                              base64Encode(bytes!.buffer.asUint8List());
                          final file =
                              File.fromRawPath(bytes.buffer.asUint8List());
                          final fileSign =
                              await saveImageToFile(bytes.buffer.asUint8List());
                          if (fileSign != null) {
                            var imgRes = await httpsClient.uploadFile(
                                "/admin/base/comm/upload",
                                file: File(fileSign.path));
                            if (imgRes != null) {
                              if (imgRes.data["message"] == "success") {
                                //保存
                                widget.changeSignature(imgRes.data["data"]);
                                // pretreatmentDetailController
                                //     .changeSignature(imgRes.data["data"]);
                                Get.closeAllSnackbars();

                                Get.back();
                                showCustomSnackbar(
                                    message: 'Upload successful.');
                              }
                            } else {
                              showCustomSnackbar(
                                  message: 'Upload failed.', status: '3');
                            }
                          }
                        },
                        child: Text("Save")),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign!.clear();
                          setState(() {
                            _img = ByteData(0);
                          });
                          debugPrint("cleared");
                        },
                        child: Text("Clear")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            color = color == Colors.black
                                ? AppColors.logoBgc
                                : Colors.black;
                          });
                          debugPrint("change color");
                        },
                        child: Text("Change color")),
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            int min = 1;
                            int max = 10;
                            int selection = min + (Random().nextInt(max - min));
                            strokeWidth = selection.roundToDouble();
                            debugPrint("change stroke width to $selection");
                          });
                        },
                        child: Text("Change stroke width")),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
