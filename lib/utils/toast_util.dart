import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ToastUtil {
  // 内部方法：根据平台选择显示方式
  static void _showToast(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData? icon,
    Duration duration,
  ) {
    // Web平台使用SnackBar
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon, color: Colors.white),
            ),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.05,
        left: 16.0,
        right: 16.0,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 显示短时间的Toast消息
  static void showShort(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.grey[700] ?? Colors.grey,
      null,
      const Duration(seconds: 2),
    );
  }

  // 显示长时间的Toast消息
  static void showLong(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.grey[700] ?? Colors.grey,
      null,
      const Duration(seconds: 4),
    );
  }

  // 显示成功Toast
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.green,
      Icons.check_circle,
      const Duration(seconds: 2),
    );
  }

  // 显示错误Toast
  static void showError(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.red,
      Icons.error,
      const Duration(seconds: 2),
    );
  }

  // 显示警告Toast
  static void showWarning(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.orange,
      Icons.warning,
      const Duration(seconds: 2),
    );
  }

  // 显示信息Toast
  static void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Colors.blue,
      Icons.info,
      const Duration(seconds: 2),
    );
  }

  // 显示自定义SnackBar (跨平台实现)
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message,
      backgroundColor ?? (Colors.grey[700] ?? Colors.grey),
      icon,
      duration,
    );
  }

  // 显示确认对话框
  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = '确认',
    String cancelText = '取消',
    Color confirmColor = Colors.red,
    Color cancelColor = Colors.grey,
  }) async {
    bool? result;

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {
        result = true;
      },
      btnCancelOnPress: () {
        result = false;
      },
      btnOkText: confirmText,
      btnCancelText: cancelText,
      btnOkColor: confirmColor,
      btnCancelColor: cancelColor,
    ).show();

    return result;
  }

  // 显示信息对话框
  static Future<void> showAlertDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = '确定',
    Color confirmColor = Colors.blue,
  }) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkText: confirmText,
      btnOkColor: confirmColor,
    ).show();
  }

  // 显示成功对话框
  static Future<void> showSuccessDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = '确定',
  }) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkText: confirmText,
    ).show();
  }

  // 显示错误对话框
  static Future<void> showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = '确定',
  }) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkText: confirmText,
    ).show();
  }
}
