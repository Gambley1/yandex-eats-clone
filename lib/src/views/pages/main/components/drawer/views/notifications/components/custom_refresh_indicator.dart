import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatefulWidget {
  const CustomRefreshIndicator({super.key});

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  bool _isRefreshing = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Refresh Indicator'),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.delta.dy;
            // To limit the drag offset to a specific value, adjust the following line
            _dragOffset = _dragOffset.clamp(0.0, 100.0);
          });
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset >= 100.0 && !_isRefreshing) {
            setState(() {
              _isRefreshing = true;
              _startRefreshing();
            });
          } else {
            setState(() {
              _dragOffset = 0.0;
            });
          }
        },
        child: Stack(
          children: [
            ListView(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    widthFactor: _isRefreshing ? _animation.value : 1.0,
                    child: child,
                  ),
                );
              },
              child: _isRefreshing
                  ? Container(
                      width: double.infinity,
                      height: 56,
                      color: Colors.blue,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 56,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          'Pull to Refresh',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startRefreshing() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isRefreshing = false;
      _dragOffset = 0.0;
    });
  }
}
