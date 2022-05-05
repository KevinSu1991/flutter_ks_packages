import 'package:flutter/material.dart';

abstract class KSBaseWidget extends StatefulWidget {
  const KSBaseWidget({Key? key}) : super(key: key);

  @override
  KSBaseWidgetState createState() {
    return getState();
  }

  KSBaseWidgetState getState();
}

abstract class KSBaseWidgetState<T extends KSBaseWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    onCreate();
    debugPrint("${T.toString()} initState");
  }

  @override
  void didChangeDependencies() {
    debugPrint("${T.toString()} didChangeDependencies");
    onChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return onBuild(context);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    debugPrint("${T.toString()} didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    debugPrint("${T.toString()} reassemble");
    super.reassemble();
  }

  @override
  void deactivate() {
    debugPrint("${T.toString()} deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint("${T.toString()} dispose");
    onDispose();
    super.dispose();
  }

  onCreate();

  onBuild(BuildContext context) {}

  onDispose();

  onChangeDependencies();
}
