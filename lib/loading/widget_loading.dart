import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KSLoadingDialog extends Dialog {
  final BuildContext context;
  late double dialogContentWidth;
  late double dialogContentHeight;

  String? dialogTitle;
  TextStyle? dialogTextStyle;
  bool dialogCanClose = false;
  bool _dialogIsShown = false;

  KSLoadingDialog(this.context, {Key? key, String? title, TextStyle? textStyle, bool? canClose, bool? isShown, double? width, double? height})
      : super(key: key) {
    dialogTitle = title;
    dialogTextStyle = textStyle;
    dialogCanClose = canClose ?? false;
    _dialogIsShown = isShown ?? false;
    dialogContentWidth = width ?? 80;
    dialogContentHeight = height ?? 80;
  }

  show() {
    _dialogIsShown = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => KSLoadingDialog(
              context,
              canClose: dialogCanClose,
              isShown: _dialogIsShown,
            ));
  }

  void dismiss() {
    if (_dialogIsShown) {
      _dialogIsShown = false;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
          width: dialogContentWidth,
          height: dialogContentHeight,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        width: dialogContentWidth,
                        height: dialogContentHeight,
                        child: Lottie.asset("lib/assets/lottie/loading.json"),
                      ),
                      Offstage(
                        offstage: dialogTitle == null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            dialogTitle ?? "",
                            style: dialogTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Offstage(
                  offstage: !dialogCanClose,
                  child: GestureDetector(
                    onTap: () {
                      dismiss();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.topRight,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white30,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
