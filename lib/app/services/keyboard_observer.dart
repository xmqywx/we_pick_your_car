import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef FunctionType = void Function(bool isKeyboardShow);

class KeyBoardObserver extends WidgetsBindingObserver {
  double keyboardHeight = 0;
  bool? isKeyboardShow;
  bool? _preKeyboardShow;
  bool? isOpening;
  static const KEYBOARD_MAX_HEIGHT = "keyboard_max_height";
  double preBottom = -1;
  double lastBottom = -1;
  int times = 0;

  KeyBoardObserver._() {
    _getHeightToSp();
  }

  static final KeyBoardObserver _instance = KeyBoardObserver._();

  static KeyBoardObserver get instance => _instance;

  FunctionType? listener;

  void addListener(FunctionType listener) {
    this.listener = listener;
  }

  @override
  void didChangeMetrics() {
    times++;
    final bottom = MediaQueryData.fromWindow(window).viewInsets.bottom;
    if (times == 1) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (bottom != 0 && times < 3 && bottom == preBottom) {
          keyboardHeight = bottom;
          listener?.call(bottom == 0);
          saveHeightToSp();
          times = 0;
        }
      });
    }
    keyboardHeight = max(keyboardHeight, bottom);

    if (bottom == 0 && keyboardHeight != 0) {
      isKeyboardShow = false;
    } else if (bottom == keyboardHeight) {
      isKeyboardShow = true;
    } else {
      isKeyboardShow = null;
      if (_preKeyboardShow == false) {
        isOpening = true;
      }
      if (_preKeyboardShow == true) {
        isOpening = false;
      }
      if (isOpening == true) {
        if (bottom > 250) {
          lastBottom = bottom;
          Future.delayed(const Duration(milliseconds: 100), () {
            final bottom = MediaQueryData.fromWindow(window).viewInsets.bottom;
            if (lastBottom == bottom && isKeyboardShow == null) {
              keyboardHeight = bottom;
              isKeyboardShow = true;
            }
          });
        }
      }
    }

    if (isKeyboardShow != null &&
        _preKeyboardShow != isKeyboardShow &&
        keyboardHeight != 0) {
      times = 0;
      listener?.call(isKeyboardShow == true);
      if (bottom == 0 && keyboardHeight != 0) {
        saveHeightToSp();
      }
    }
    _preKeyboardShow = isKeyboardShow;
    preBottom = bottom;
  }

  Future<void> saveHeightToSp() async {
    final instance = await SharedPreferences.getInstance();
    instance.setDouble(KEYBOARD_MAX_HEIGHT, keyboardHeight);
  }

  void _getHeightToSp() async {
    if (keyboardHeight == 0) {
      final instance = await SharedPreferences.getInstance();
      keyboardHeight = instance.getDouble(KEYBOARD_MAX_HEIGHT) ?? 0;
    }
  }

  Future<double> getKeyBordHeight() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getDouble(KEYBOARD_MAX_HEIGHT) ?? 0;
  }
}
