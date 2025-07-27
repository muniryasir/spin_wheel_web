import 'dart:math';
import 'package:flutter/material.dart';

class SpinWheel extends StatefulWidget {
  final List<String> items;
  final ValueNotifier<int> selectedIndexNotifier;

  const SpinWheel({
    Key? key,
    required this.items,
    required this.selectedIndexNotifier,
  }) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.selectedIndexNotifier.value = _currentIndex;
      }
    });
  }

  void _spin() {
    final random = Random();
    final itemCount = widget.items.length;
    final spins = 5; // Number of full spins for effect
    _currentIndex = random.nextInt(itemCount);
    final anglePerItem = 2 * pi / itemCount;
    final targetAngle = (spins * 2 * pi) + (_currentIndex * anglePerItem);
    final startAngle = _angle;
    _animation = Tween<double>(begin: startAngle, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.reset();
    _controller.forward();
    _angle = targetAngle % (2 * pi);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;
    final anglePerItem = 2 * pi / itemCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _spin,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: child,
              );
            },
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < itemCount; i++)
                    _buildPrizeLabel(
                      widget.items[i],
                      anglePerItem * i,
                      110,
                    ),
                  // Center pointer
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _spin,
          child: const Text('Spin'),
        ),
      ],
    );
  }

  Widget _buildPrizeLabel(String text, double angle, double radius) {
    final x = radius * cos(angle - pi / 2);
    final y = radius * sin(angle - pi / 2);
    return Positioned(
      left: 125 + x - 30, // 125 is half of container size, 30 is half label width
      top: 125 + y - 12,  // 12 is half label height
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          width: 60,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              shadows: [Shadow(blurRadius: 2, color: Colors.black)],
            ),
          ),
        ),
      ),
    );
  }
}