import 'package:flutter/material.dart';
import 'ks_popup_custom_widget.dart';

class KSPopupUtils {
  static showCustomPopup({required BuildContext context, required Widget contentWidget, required KSCustomPopupWidgetController controller}) {
    Navigator.push(context, KSCustomPopupRoute(customPopupWidgetController: controller, contentWidget: contentWidget));
  }
}
