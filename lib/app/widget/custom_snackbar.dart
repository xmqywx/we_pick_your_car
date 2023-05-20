import 'package:flutter/material.dart';
import 'dart:async';

class CustomSnackbar {
  static final CustomSnackbar _singleton = CustomSnackbar._internal();

  factory CustomSnackbar() {
    return _singleton;
  }

  CustomSnackbar._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) async {
    // 如果当前已经显示了弹窗，直接返回
    if (_isVisible) return;

    // 创建一个 Text Widget 作为弹窗内容
    var text = Text(
      message,
      style: TextStyle(color: Colors.white),
    );

    // 创建一个 Material Widget 作为弹窗背景
    var material = Material(
      color: Colors.black87,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(child: text),
      ),
    );

    // 创建一个 OverlayEntry 并将其插入到 Overlay 中
    _overlayEntry = OverlayEntry(builder: (context) => material);
    Overlay.of(context)?.insert(_overlayEntry!);

    // 标记当前弹窗已经显示
    _isVisible = true;

    // 等待一段时间后关闭弹窗
    Timer(duration, () {
      _overlayEntry?.remove();
      _isVisible = false;
    });
  }
}
