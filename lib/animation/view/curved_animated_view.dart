import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class KSCurvedAnimatedView extends StatefulWidget {
  final Widget containerWidget;
  final AnimationController animationController;
  final Animation<double> animation;
  final KSCurvedAnimatedViewConfigs configs;

  const KSCurvedAnimatedView(
      {Key? key, required this.containerWidget, required this.animationController, required this.animation, required this.configs})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _KSCurvedAnimatedViewState();
}

class _KSCurvedAnimatedViewState extends State<KSCurvedAnimatedView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, _) {
          return FadeTransition(
            opacity: widget.animation,
            child: Transform(
              transform: widget.configs.animatedDirection == directionBottom2top
                  ? Matrix4.translationValues(0, 100 * (1.0 - widget.animation.value), 0)
                  : Matrix4.translationValues(100 * (1.0 - widget.animation.value), 0, 0),
              child: widget.containerWidget,
            ),
          );
        });
  }
}

///从下往上
const int directionBottom2top = 0;

///从右往左
const int directionRight2left = 1;

class KSCurvedAnimatedViewConfigs {
  final int animatedDirection;

  KSCurvedAnimatedViewConfigs({this.animatedDirection = directionBottom2top});
}
