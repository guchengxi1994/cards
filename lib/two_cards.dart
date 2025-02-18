import 'package:cards/child_wrapper.dart';
import 'package:flutter/cupertino.dart';

class TwoCards extends StatefulWidget {
  const TwoCards(
      {super.key,
      this.child1,
      this.child2,
      required this.onChild1Pressed,
      required this.onChild2Pressed});
  final Widget? child1;
  final Widget? child2;
  final VoidCallback onChild1Pressed;
  final VoidCallback onChild2Pressed;

  @override
  State<TwoCards> createState() => _TwoCardsState();
}

class _TwoCardsState extends State<TwoCards> {
  final ValueNotifier<int> notifier = ValueNotifier(0);

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  bool child1Top = false;
  bool child2Top = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50 - 100;
    final height = MediaQuery.of(context).size.height - 50 - 150;

    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (ctx, value, _) {
          List<Widget> children = [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: child1Top ? -1000 : 50,
              left: 50,
              onEnd: () {
                // notifier.value = 0;
                setState(() {
                  child1Top = false;
                });
              },
              child: ChildWrapper(
                  width: width,
                  height: height,
                  isOnTop: value == 0,
                  onBorderPressed: () {
                    if (value == 0) {
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
              top: 100,
              left: child2Top ? 1000 : 100,
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
                    if (value == 1) {
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
