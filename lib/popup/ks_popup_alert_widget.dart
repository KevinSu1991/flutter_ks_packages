import 'package:flutter/material.dart';
import 'package:flutter_ks_packages/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KSPopupAlertWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? confirmTitle;
  final String? cancelTitle;
  final Function onCancel;
  final Function onConfirm;
  final String fontFamily;

  const KSPopupAlertWidget(
      {Key? key,
      required this.title,
      this.subTitle,
      this.confirmTitle,
      this.cancelTitle,
      required this.onCancel,
      required this.onConfirm,
      required this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                title,
                style: KSCommonUtils.getDefaultTextStyle(17.sp, const Color(0xFF191F25), fontFamily: fontFamily, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Offstage(
            offstage: subTitle == null,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                subTitle ?? "",
                style: KSCommonUtils.getDefaultTextStyle(14.sp, const Color(0xFF555555), fontFamily: fontFamily),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
          ),
          const Divider(
            color: Color(0xFFEDF0F3),
            height: 0.5,
          ),
          Container(
              width: double.infinity,
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      /// 点击了取消
                      onCancel();
                    },
                    child: Text(
                      cancelTitle ?? "Cancel",
                      style: KSCommonUtils.getDefaultTextStyle(17, const Color(0xFF242424), fontFamily: fontFamily),
                    ),
                  )),
                  Container(
                    width: 0.5,
                    height: double.infinity,
                    color: const Color(0xFFEDF0F3),
                  ),
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      /// 点击了确定
                      onConfirm();
                    },
                    child: Text(
                      confirmTitle ?? "Confirm",
                      style: KSCommonUtils.getDefaultTextStyle(17.sp, const Color(0xFF006FFF), fontFamily: fontFamily),
                    ),
                  )),
                ],
              ))
        ],
      ),
    );
  }
}
