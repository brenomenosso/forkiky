import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forkify_app/src/components/circle.dart';

class LoadingDots extends StatefulWidget {
  final String? title;

  const LoadingDots({Key? key, this.title}) : super(key: key);

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> {
  double dot1 = 1;
  double dot2 = 1;
  double dot3 = 1;
  int counter = 0;

  Timer timer = Timer.periodic(const Duration(milliseconds: 500), ((timer) {}));
  bool isStarted = false;

  void changeSize() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (counter == 0) {
          dot1 = 2;
          dot2 = 1;
          dot3 = 1;
        } else if (counter == 1) {
          dot1 = 1;
          dot2 = 2;
          dot3 = 1;
        } else {
          dot1 = 1;
          dot2 = 1;
          dot3 = 2;
        }
        counter++;
        if (counter > 2) {
          counter = 0;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    changeSize();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: dot1),
              duration: const Duration(microseconds: 500),
              builder: (_, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: const Circle(),
            ),
            const SizedBox(
              width: 16,
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: dot2),
              duration: const Duration(microseconds: 500),
              builder: (_, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: const Circle(),
            ),
            const SizedBox(
              width: 16,
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: dot3),
              duration: const Duration(microseconds: 500),
              builder: (_, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: const Circle(),
            )
          ],
        ),
        const SizedBox(height: 12),
        Text(widget.title ?? 'Carregando', style: const TextStyle(color: Colors.black))
      ],
    );
  }
}
