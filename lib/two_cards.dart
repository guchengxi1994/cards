import 'dart:async';

import 'package:cards/child_wrapper.dart';
import 'package:flutter/cupertino.dart';

class TwoCards extends StatefulWidget {
  const TwoCards(
      {super.key,
      this.child1,
      this.child2,
      required this.onChild1Pressed,
      required this.onChild2Pressed,
      this.marginLeft = 30,
      this.marginTop = 30,
      this.marginEachOther = 30,
      this.width,
      this.height,
      this.autoAnimate = false,
      this.duration = const Duration(seconds: 5)})
      : assert((width == null || width > marginLeft * 2 + marginEachOther) &&
            (height == null || height > marginTop * 2 + marginEachOther));
  final Widget? child1;
  final Widget? child2;
  final VoidCallback onChild1Pressed;
  final VoidCallback onChild2Pressed;
  final double marginTop;
  final double marginLeft;
  final double marginEachOther;
  final double? width;
  final double? height;
  final bool autoAnimate;
  final Duration duration;

  @override
  State<TwoCards> createState() => _TwoCardsState();
}

class _TwoCardsState extends State<TwoCards> {
  final ValueNotifier<int> notifier = ValueNotifier(0);
  late Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = widget.autoAnimate
        ? Timer.periodic(widget.duration, (_) async {
            Future.microtask(() {
              setState(() {
                if (notifier.value == 0) {
                  child1Top = !child1Top;
                } else {
                  child2Top = !child2Top;
                }
              });
            }).then((_) {
              Future.delayed(Duration(milliseconds: 500)).then((_) {
                if (notifier.value == 0) {
                  notifier.value = 1;
                } else {
                  notifier.value = 0;
                }
              });
            });
          })
        : null;
  }

  @override
  void dispose() {
    notifier.dispose();
    timer?.cancel();
    super.dispose();
  }

  bool child1Top = false;
  bool child2Top = false;

  @override
  Widget build(BuildContext context) {
    final width = widget.width ??
        MediaQuery.of(context).size.width -
            2 * widget.marginLeft -
            widget.marginEachOther;
    final height = widget.height ??
        MediaQuery.of(context).size.height -
            2 * widget.marginTop -
            widget.marginEachOther;

    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (ctx, value, _) {
          List<Widget> children = [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: child1Top ? -height : widget.marginTop,
              left: widget.marginLeft,
              onEnd: () {
                setState(() {
                  child1Top = false;
                });
              },
              child: ChildWrapper(
                  width: width,
                  height: height,
                  isOnTop: value == 0,
                  onBorderPressed: () {
                    if (value == 0 || widget.autoAnimate) {
                      return;
                    }

                    Future.delayed(Duration(milliseconds: 499)).then((_) {
                      notifier.value = 0;
                    });
                    setState(() {
                      child1Top = true;
                    });
                  },
                  onContentPressed: () {
                    widget.onChild1Pressed();
                  },
                  child: widget.child1),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: widget.marginTop + widget.marginEachOther,
              left: child2Top
                  ? width
                  : widget.marginLeft + widget.marginEachOther,
              onEnd: () {
                setState(() {
                  child2Top = false;
                });
              },
              child: ChildWrapper(
                  width: width,
                  height: height,
                  isOnTop: value == 1,
                  onBorderPressed: () {
                    if (value == 1 || widget.autoAnimate) {
                      return;
                    }

                    Future.delayed(Duration(milliseconds: 499)).then((_) {
                      notifier.value = 1;
                    });
                    setState(() {
                      child2Top = true;
                    });
                  },
                  onContentPressed: () {
                    widget.onChild2Pressed();
                  },
                  child: widget.child2),
            ),
          ];
          if (value == 0) {
            children = children.reversed.toList();
          }

          return Stack(
            children: [SizedBox.expand(), ...children],
          );
        });
  }
}
