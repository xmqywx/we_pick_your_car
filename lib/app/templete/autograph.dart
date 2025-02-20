import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _controller = HandwrittenSignatureController();
  Uint8List? _savedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: HandwrittenSignatureWidget(
            controller: _controller,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _controller.saveImage().then((value) => setState(() {
                        _savedImage = value;
                      }));
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  _controller.reset();
                  setState(() {
                    _savedImage = null;
                  });
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ],
          ),
          Expanded(
            child: _savedImage == null
                ? const SizedBox()
                : Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange),
                      ),
                      child: Image.memory(
                        _savedImage!,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class HandwrittenSignatureController {
  Function? _reset;
  Future<Uint8List?> Function()? _saveImage;

  void reset() {
    _reset?.call();
  }

  Future<Uint8List?> saveImage() {
    return _saveImage?.call() ?? Future.value(null);
  }
}

class HandwrittenSignatureWidget extends StatefulWidget {
  final HandwrittenSignatureController? controller;

  const HandwrittenSignatureWidget({Key? key, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HandwrittenSignatureWidgetState();
}

class _HandwrittenSignatureWidgetState
    extends State<HandwrittenSignatureWidget> {
  // 记录一次 不间断的手势路径 即记录一次 笔画
  Path? _path;

  // 在一次不间断的移动过程中 记录上一坐标点 用于在前后2点之间绘制贝塞尔曲线
  Offset? _previousOffset;

  // 记录所有的笔画 可拼凑成完整字
  final List<Path?> _pathList = [];

  @override
  void initState() {
    super.initState();
    widget.controller?._reset = () {
      setState(() {
        _pathList.clear();
      });
    };
    widget.controller?._saveImage = () => _generateImage();
  }

  Future<Uint8List?> _generateImage() async {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2
      ..isAntiAlias = true;

    // 计算所有笔画 涉及的最大区域
    Rect? bound;
    for (Path? path in _pathList) {
      if (path != null) {
        var rect = path.getBounds();
        if (bound == null) {
          bound = rect;
        } else {
          bound = bound.expandToInclude(rect);
        }
      }
    }

    // 如果签名区域太小，则使用一个默认的最小尺寸
    const double minSignatureSize = 50.0;
    if (bound == null) {
      bound = Rect.fromLTWH(0, 0, minSignatureSize, minSignatureSize);
    } else {
      if (bound.width < minSignatureSize) {
        bound = Rect.fromLTWH(
            bound.left, bound.top, minSignatureSize, bound.height);
      }
      if (bound.height < minSignatureSize) {
        bound =
            Rect.fromLTWH(bound.left, bound.top, bound.width, minSignatureSize);
      }
    }

    final size = bound.size;
    // PictureRecorder 记录画布上产生的行为
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, bound);

    for (Path? path in _pathList) {
      if (path != null) {
        // padding 是20 ，然后将路径偏移至左上角（20，20）
        var offsetPath = path.shift(Offset(20 - bound.left, 20 - bound.top));
        canvas.drawPath(offsetPath, paint);
      }
    }

    // 结束记录
    final picture = recorder.endRecording();
    // 因为padding为20，所以整体宽高要+40
    ui.Image img = await picture.toImage(
        size.width.toInt() + 40, size.height.toInt() + 40);
    // 转换为png格式的图片数据
    var bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return bytes?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //手解除到屏幕，在开始移动了
      onPanStart: (details) {
        // 获取当前的坐标
        var position = details.localPosition;
        setState(() {
          // 每次重新开始时就是新的Path对象
          _path = Path()..moveTo(position.dx, position.dy);
          _previousOffset = position;
        });
      },
      //持续移动中
      onPanUpdate: (details) {
        // 获取当前的坐标
        var position = details.localPosition;
        var dx = position.dx;
        var dy = position.dy;

        setState(() {
          final previousOffset = _previousOffset;
          //如果没有上一坐标点
          if (previousOffset == null) {
            _path?.lineTo(dx, dy);
          } else {
            var previousDx = previousOffset.dx;
            var previousDy = previousOffset.dy;
            // 已贝塞尔曲线的方式连线
            _path?.quadraticBezierTo(
              previousDx,
              previousDy,
              (previousDx + dx) / 2,
              (previousDy + dy) / 2,
            );
          }
          _previousOffset = position;
        });
      },
      // 手停止了移动 离开了屏幕
      onPanEnd: (details) {
        // 记录笔画，然后清空临时变量
        setState(() {
          _pathList.add(_path);
          _previousOffset = null;
          _path = null;
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: SignaturePainter(_pathList, _path),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  // 绘制签名需要 历史的笔画
  final List<Path?> pathList;

  // 当前正在写 的笔画
  final Path? currentPath;

  SignaturePainter(this.pathList, this.currentPath);

  // 设置画笔的属性
  final _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round // 线条两端的形状
    ..strokeJoin = StrokeJoin.round // 2条线段连接处的形状
    ..strokeWidth = 2 //线宽
    ..isAntiAlias = true; //抗锯齿

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制以前写过的笔画
    for (Path? path in pathList) {
      _drawLine(canvas, path);
    }
    // 绘制当前正在写的笔画
    _drawLine(canvas, currentPath);
  }

  void _drawLine(Canvas canvas, Path? path) {
    if (path == null) return;
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
