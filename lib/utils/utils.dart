import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class KSCommonUtils {
  static String getImgPath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getJsonPath(String name, {String format = 'json'}) {
    return 'assets/json/$name.$format';
  }

  ///APP默认文字使用本地的ttf文件
  static TextStyle getDefaultTextStyle(double fontSize, Color textColor, {required String fontFamily, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: fontWeight, color: textColor, backgroundColor: Colors.transparent);
  }

  static TextStyle getTextStyle(
      {required String fontFamily,
      required FontWeight fontWeight,
      required double fontSize,
      required FontStyle fontStyle,
      required Color textColor,
      required Color backgroundColor,
      Paint? foreground}) {
    return GoogleFonts.getFont(fontFamily,
        fontStyle: fontStyle,
        textStyle: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: textColor, backgroundColor: backgroundColor),
        foreground: foreground);
  }

  ///设置状态栏透明
  static void statusBarStyle({required Brightness brightness, required Color statusBarColor}) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarBrightness: brightness, //for ios
        statusBarColor: statusBarColor //for android
        );
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static void showSucceedToast(String message) {
    _showToast(message, Colors.green);
  }

  static void showErrorToast(String message) {
    _showToast(message, Colors.red);
  }

  static void _showToast(String message, Color bgColor, {double fontSize = 13}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: fontSize);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  ///保存本地图片
  static void saveLocalImage(Uint8List imageBytes, int quality) {
    ImageGallerySaver.saveImage(imageBytes, quality: 100);
  }

  ///保存网络图片
  static Future<bool> saveNetworkImageToGallery(String url) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(bytes, quality: 100);
    return Future.value(result["isSuccess"]);
  }

  ///保存网路图片至本地指定目录
  static Future<void> saveNetworkImageToLocal({required String imageUrl, required String localUrl}) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl)).buffer.asUint8List();
    await File(localUrl).writeAsBytes(bytes);
    return Future.value(true);
  }

  ///数字格式化
  static String formattedNumber(int number) {
    double mDouble = number / 1000000;
    int m = mDouble.floor();
    if (m != 0) {
      return "${_format(mDouble)}m";
    }
    double kDouble = number / 1000;
    int k = kDouble.floor();
    if (k != 0) {
      return "${_format(kDouble)}k";
    }
    return "$number";
  }

  static String _format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  ///日期格式化
  static String formattedDate(DateTime date) {
    var now = DateTime.now();
    var secondsDiff = now.difference(date).inSeconds;
    if (secondsDiff <= 5) {
      return "just recently";
    } else if (secondsDiff < 60) {
      return "$secondsDiff seconds ago";
    }
    var minutesDiff = now.difference(date).inMinutes;
    if (minutesDiff < 60) {
      return "$minutesDiff minutes ago";
    }
    var hoursDiff = now.difference(date).inHours;
    if (hoursDiff < 24) {
      return "$hoursDiff hours ago";
    }
    var days = now.difference(date).inDays;
    if (days < 30) {
      return "$days days ago";
    }
    final f = DateFormat('yyyy-MM-dd hh:mm');
    return f.format(date);
  }

  static String formattedShortDate(DateTime date) {
    var now = DateTime.now();
    var secondsDiff = now.difference(date).inSeconds;
    if (secondsDiff < 60) {
      return "${secondsDiff}s";
    }
    var minutesDiff = now.difference(date).inMinutes;
    if (minutesDiff < 60) {
      return "${minutesDiff}m";
    }
    var hoursDiff = now.difference(date).inHours;
    if (hoursDiff < 24) {
      return "${hoursDiff}h";
    }
    var days = now.difference(date).inDays;
    if (days < 7) {
      return "${days}d";
    } else {
      int weeks = (days / 7) as int;
      return "${weeks}w";
    }
  }

  ///下拉刷新控件自定义header
  static CustomHeader customRefreshHeader({required Color textColor, required String fontFamily}) {
    return CustomHeader(builder: (context, mode) {
      Widget body;
      if (mode == RefreshStatus.idle) {
        body = Text(
          "pull down to refresh",
          style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily),
        );
      } else if (mode == RefreshStatus.refreshing) {
        body = Lottie.asset("assets/lottie/loading.json", width: 30, height: 30);
      } else if (mode == RefreshStatus.failed) {
        body = Text("refresh failed", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else if (mode == RefreshStatus.canRefresh) {
        body = Text("release to refresh", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else if (mode == RefreshStatus.completed) {
        body = Text("refresh completed", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else {
        body = const Text("");
      }
      return SizedBox(
        height: 60,
        child: Center(
          child: body,
        ),
      );
    });
  }

  static CustomFooter customLoadFooter({required Color textColor, required String fontFamily}) {
    return CustomFooter(builder: (context, mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = Text(
          "",
          style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily),
        );
      } else if (mode == LoadStatus.loading) {
        body = Lottie.asset("assets/lottie/loading.json", width: 30, height: 30);
      } else if (mode == LoadStatus.failed) {
        body = Text("", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else if (mode == LoadStatus.canLoading) {
        body = Text("release to load", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else if (mode == LoadStatus.noMore) {
        body = Text("", style: getDefaultTextStyle(13, textColor, fontFamily: fontFamily));
      } else {
        body = const Text("");
      }
      return SizedBox(
        height: 60,
        child: Center(
          child: body,
        ),
      );
    });
  }
}
