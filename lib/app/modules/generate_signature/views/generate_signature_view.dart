import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../controllers/generate_signature_controller.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/https_client.dart';
import '../../../widget/toast.dart';
import '../../pretreatment_detail/controllers/pretreatment_detail_controller.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import '../../../color/colors.dart';

class GenerateSignatureView extends GetView<GenerateSignatureController> {
  const GenerateSignatureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Generate signature'),
          centerTitle: true,
        ),
        body: const DemoPage());
  }
}

// class DemoPage extends StatefulWidget {
//   const DemoPage({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _DemoPageState();
// }

// class _DemoPageState extends State<DemoPage> {
//   final _controller = HandwrittenSignatureController();
//   Uint8List? _savedImage;
//   // final SubmitTaskinfoController submitTaskInfoController =
//   //     Get.put(SubmitTaskinfoController());
//   final PretreatmentDetailController pretreatmentDetailController =
//       Get.put(PretreatmentDetailController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: HandwrittenSignatureWidget(
//             controller: _controller,
//           )),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   _controller.saveImage().then((value) async {
//                     _savedImage = value;

//                     final fileSign = await saveImageToFile(value);
//                     print("--------------------------");
//                     print(fileSign);
//                     print("--------------------------");
//                     if (fileSign != null) {
//                       var imgRes = await httpsClient.uploadFile(
//                           "/admin/base/comm/upload",
//                           file: File(fileSign.path));
//                       if (imgRes != null) {
//                         if (imgRes.data["message"] == "success") {
//                           //保存
//                           pretreatmentDetailController
//                               .changeSignature(imgRes.data["data"]);
//                           Get.closeAllSnackbars();

//                           Get.back();
//                           showCustomSnackbar(message: 'Upload successful.');
//                           print(imgRes.data["data"]);
//                         }
//                       } else {
//                         print('upload faild');
//                         showCustomSnackbar(
//                             message: 'Upload failed.', status: '3');
//                       }
//                     }
//                   });
//                 },
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(color: Colors.black, fontSize: 20),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   _controller.reset();
//                   setState(() {
//                     _savedImage = null;
//                   });
//                 },
//                 child: const Text(
//                   'Clear',
//                   style: TextStyle(color: Colors.black, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//           // Expanded(
//           //   child: _savedImage == null
//           //       ? const SizedBox()
//           //       : Align(
//           //           alignment: Alignment.topLeft,
//           //           child: Container(
//           //             margin: const EdgeInsets.all(10),
//           //             decoration: BoxDecoration(
//           //               border: Border.all(color: Colors.deepOrange),
//           //             ),
//           //             child: Image.memory(
//           //               _savedImage!,
//           //               filterQuality: FilterQuality.high,
//           //             ),
//           //           ),
//           //         ),
//           // ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }

// class HandwrittenSignatureController {
//   Function? _reset;
//   Future<Uint8List?> Function()? _saveImage;

//   void reset() {
//     _reset?.call();
//   }

//   Future<Uint8List?> saveImage() {
//     return _saveImage?.call() ?? Future.value(null);
//   }
// }

// class HandwrittenSignatureWidget extends StatefulWidget {
//   final HandwrittenSignatureController? controller;

//   const HandwrittenSignatureWidget({Key? key, this.controller})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _HandwrittenSignatureWidgetState();
// }

// class _HandwrittenSignatureWidgetState
//     extends State<HandwrittenSignatureWidget> {
//   // 记录一次 不间断的手势路径 即记录一次 笔画
//   Path? _path;

//   // 在一次不间断的移动过程中 记录上一坐标点 用于在前后2点之间绘制贝塞尔曲线
//   Offset? _previousOffset;

//   // 记录所有的笔画 可拼凑成完整字
//   final List<Path?> _pathList = [];

//   @override
//   void initState() {
//     super.initState();
//     widget.controller?._reset = () {
//       setState(() {
//         _pathList.clear();
//       });
//     };
//     widget.controller?._saveImage = () => _generateImage();
//   }

//   /// 生成Padding为20的 只包含绘制区域的图片
//   /// import 'dart:ui' as ui;
//   Future<Uint8List?> _generateImage() async {
//     var paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..strokeWidth = 2
//       ..isAntiAlias = true;

//     // 计算所有笔画 涉及的最大区域
//     Rect? bound;
//     for (Path? path in _pathList) {
//       if (path != null) {
//         var rect = path.getBounds();
//         if (bound == null) {
//           bound = rect;
//         } else {
//           bound = bound.expandToInclude(rect);
//         }
//       }
//     }
//     if (bound == null) {
//       return null;
//     }

//     final size = bound.size;
//     // PictureRecorder 记录画布上产生的行为
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder, bound);

//     for (Path? path in _pathList) {
//       if (path != null) {
//         // padding 是20 ，然后将路径偏移至左上角（20，20）
//         var offsetPath = path.shift(Offset(20 - bound.left, 20 - bound.top));
//         canvas.drawPath(offsetPath, paint);
//       }
//     }

//     // 结束记录
//     final picture = recorder.endRecording();
//     // 因为padding为20，所以整体宽高要+40
//     ui.Image img = await picture.toImage(
//         size.width.toInt() + 40, size.height.toInt() + 40);
//     // 转换为png格式的图片数据
//     var bytes = await img.toByteData(format: ui.ImageByteFormat.png);
//     return bytes?.buffer.asUint8List();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       //手解除到屏幕，在开始移动了
//       onPanStart: (details) {
//         // 获取当前的坐标
//         var position = details.localPosition;
//         setState(() {
//           // 每次重新开始时就是新的Path对象
//           _path = Path()..moveTo(position.dx, position.dy);
//           _previousOffset = position;
//         });
//       },
//       //持续移动中
//       onPanUpdate: (details) {
//         // 获取当前的坐标
//         var position = details.localPosition;
//         var dx = position.dx;
//         var dy = position.dy;

//         setState(() {
//           final previousOffset = _previousOffset;
//           //如果没有上一坐标点
//           if (previousOffset == null) {
//             _path?.lineTo(dx, dy);
//           } else {
//             var previousDx = previousOffset.dx;
//             var previousDy = previousOffset.dy;
//             // 已贝塞尔曲线的方式连线
//             _path?.quadraticBezierTo(
//               previousDx,
//               previousDy,
//               (previousDx + dx) / 2,
//               (previousDy + dy) / 2,
//             );
//           }
//           _previousOffset = position;
//         });
//       },
//       // 手停止了移动 离开了屏幕
//       onPanEnd: (details) {
//         // 记录笔画，然后清空临时变量
//         setState(() {
//           _pathList.add(_path);
//           _previousOffset = null;
//           _path = null;
//         });
//       },
//       child: CustomPaint(
//         size: Size.infinite,
//         painter: SignaturePainter(_pathList, _path),
//       ),
//     );
//   }
// }

// class SignaturePainter extends CustomPainter {
//   // 绘制签名需要 历史的笔画
//   final List<Path?> pathList;

//   // 当前正在写 的笔画
//   final Path? currentPath;

//   SignaturePainter(this.pathList, this.currentPath);

//   // 设置画笔的属性
//   final _paint = Paint()
//     ..color = Colors.black
//     ..style = PaintingStyle.stroke
//     ..strokeCap = StrokeCap.round // 线条两端的形状
//     ..strokeJoin = StrokeJoin.round // 2条线段连接处的形状
//     ..strokeWidth = 2 //线宽
//     ..isAntiAlias = true; //抗锯齿

//   @override
//   void paint(Canvas canvas, Size size) {
//     // 绘制以前写过的笔画
//     for (Path? path in pathList) {
//       _drawLine(canvas, path);
//     }
//     // 绘制当前正在写的笔画
//     _drawLine(canvas, currentPath);
//   }

//   void _drawLine(Canvas canvas, Path? path) {
//     if (path == null) return;
//     canvas.drawPath(path, _paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

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

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
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

class _DemoPageState extends State<DemoPage> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  final PretreatmentDetailController pretreatmentDetailController =
      Get.put(PretreatmentDetailController());
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
                                pretreatmentDetailController
                                    .changeSignature(imgRes.data["data"]);
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
                        child: const Text("Save")),
                    const SizedBox(
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
                        child: const Text("Clear")),
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
                        child: const Text("Change color")),
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
                        child: const Text("Change stroke width")),
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
