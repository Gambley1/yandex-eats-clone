import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

///Animates the child
///
///using TweenAnimationBuilder
class FadeAnimation extends StatelessWidget {
  const FadeAnimation({
    required this.child,
    super.key,
    this.begin = 0,
    this.end = 1,
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 3000),
    this.curve = Curves.fastOutSlowIn,
  });

  ///Animate from value
  ///
  ///[default value 0]
  final double begin;

  ///Animate to value
  ///
  ///[default value 1]
  final double end;

  ///Animation Duration
  ///
  ///[default is 750ms]
  final Duration duration;

  ///Animation delay
  ///
  ///[default is 0]
  final double intervalStart;

  ///Animation delay
  ///
  ///[default is 1]
  final double intervalEnd;

  ///Animation Curve
  ///
  ///[default is Curves.fastOutSlowIn]
  final Curve curve;

  ///This widget will be animated
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: Interval(intervalStart, intervalEnd, curve: curve),
      child: child,
      builder: (context, value, child) {
        return AnimatedOpacity(
          duration: 150.ms,
          opacity: value,
          child: child,
        );
      },
    );
  }
}
