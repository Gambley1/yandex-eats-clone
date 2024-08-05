import 'package:flutter/material.dart';

class SmoothPaymentProgressIndicator extends StatefulWidget {
  const SmoothPaymentProgressIndicator({super.key});

  @override
  State<SmoothPaymentProgressIndicator> createState() =>
      _SmoothPaymentProgressIndicatorState();
}

class _SmoothPaymentProgressIndicatorState
    extends State<SmoothPaymentProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 50,
      ),
    );

    _animation = Tween<double>(begin: 0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const SlowdownCurve(0.3),
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }
}

class SlowdownCurve extends Curve {
  const SlowdownCurve(this.slowdownStart);

  final double slowdownStart;

  @override
  double transform(double t) {
    return t < slowdownStart
        ? t
        : slowdownStart + (t - slowdownStart) * slowdownStart;
  }
}
