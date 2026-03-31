import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoldToBuyButton extends StatefulWidget {
  final VoidCallback onTrigger;
  final String label;

  const HoldToBuyButton({
    super.key,
    required this.onTrigger,
    this.label = "Hold to Buy",
  });

  @override
  State<HoldToBuyButton> createState() => _HoldToBuyButtonState();
}

class _HoldToBuyButtonState extends State<HoldToBuyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSuccess = true;
          _isHolding = false;
        });
        widget.onTrigger();
        HapticFeedback.heavyImpact();
      }
    });

    _controller.addListener(() {
      if (_controller.value > 0 && _controller.value < 1.0) {
        if ((_controller.value * 20).toInt() % 2 == 0) {
          HapticFeedback.selectionClick();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (_isSuccess) return;
    setState(() => _isHolding = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(_) {
    if (_isSuccess) return;
    setState(() => _isHolding = false);
    if (_controller.status != AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _onTapUp(null),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _isSuccess
            ? _buildSuccessCircle()
            : _buildInteractiveCircle(),
      ),
    );
  }

  Widget _buildSuccessCircle() {
    return Container(
      key: const ValueKey('success'),
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF00E676),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x6600E676),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildInteractiveCircle() {
    return Stack(
      key: const ValueKey('interactive'),
      alignment: Alignment.center,
      children: [
        // Static Background Circle
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _isHolding ? Colors.white.withAlpha(38) : Colors.white.withAlpha(20),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withAlpha(30),
              width: 2,
            ),
          ),
        ),
        // Progressive Border
        SizedBox(
          width: 80,
          height: 80,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: CircularBorderPainter(
                  progress: _controller.value,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        // Hold Text Label (Optional or hidden)
        if (!_isHolding)
          const Icon(Icons.fingerprint, color: Colors.white54, size: 32)
        else
          Text(
            "${(_controller.value * 100).toInt()}%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}

class CircularBorderPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularBorderPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2; // Start from top
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CircularBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
