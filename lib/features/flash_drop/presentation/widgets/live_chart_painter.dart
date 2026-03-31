import 'package:flutter/material.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';

class LiveChartPainter extends CustomPainter {
  final List<PricePoint> priceHistory;
  final Color lineColor;
  final Color gradientColor;

  LiveChartPainter({
    required this.priceHistory,
    this.lineColor = const Color(0xFF00E676), // Vibrant green
    this.gradientColor = const Color(0x3300E676),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (priceHistory.isEmpty) return;

    final double minPrice = priceHistory.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final double maxPrice = priceHistory.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final double range = maxPrice - minPrice == 0 ? 1 : maxPrice - minPrice;

    final double stepX = size.width / (priceHistory.length - 1);
    final double scaleY = size.height / range;

    final Path path = Path();
    final Path areaPath = Path();

    for (int i = 0; i < priceHistory.length; i++) {
      final double x = i * stepX;
      final double y = size.height - (priceHistory[i].price - minPrice) * scaleY;

      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, size.height);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
      
      if(i == priceHistory.length - 1) {
        areaPath.lineTo(x, size.height);
        areaPath.close();
      }
    }

    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final Paint areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientColor, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(LiveChartPainter oldDelegate) {
    return oldDelegate.priceHistory != priceHistory;
  }
}
