import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void toast(
    String message, [
    ToastType type = ToastType.success,
  ]) async {
    toastification.show(
      title: Text(message, maxLines: 3),
      autoCloseDuration: const Duration(seconds: 5),
      alignment: Alignment.bottomCenter,
      type: _getToastType(type),
    );
  }

  static ToastificationType _getToastType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.info:
        return ToastificationType.info;
    }
  }
}

enum ToastType { success, error, warning, info }
