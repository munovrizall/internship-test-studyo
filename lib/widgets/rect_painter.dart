import 'package:flutter/material.dart';

class RectPainter extends CustomPainter {
  final double horizontalDivision;
  final double verticalDivision;
  final Set<Offset> selectedBoxes;

  RectPainter({
    required this.horizontalDivision,
    required this.verticalDivision,
    required this.selectedBoxes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff363636)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintRect = Paint()
      ..color = const Color(0xff627380)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final selectedPaint = Paint()
      ..color = const Color(0xff1C858B)
      ..style = PaintingStyle.fill;

    final double boxWidth = size.width / horizontalDivision;
    final double boxHeight = size.height / verticalDivision;

    // Gambar kotak utama
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paintRect);

    // Gambar garis vertikal sesuai dengan nilai horizontalDivision
    for (int i = 1; i < horizontalDivision; i++) {
      canvas.drawLine(
          Offset(boxWidth * i, 0), Offset(boxWidth * i, size.height), paint);
    }

    // Gambar garis horizontal sesuai dengan nilai verticalDivision
    for (int i = 1; i < verticalDivision; i++) {
      canvas.drawLine(
          Offset(0, boxHeight * i), Offset(size.width, boxHeight * i), paint);
    }

    // Gambar kotak yang dipilih
    for (final box in selectedBoxes) {
      final rect = Rect.fromLTWH(
        box.dx * boxWidth,
        box.dy * boxHeight,
        boxWidth - 1,
        boxHeight - 1,
      );
      canvas.drawRect(rect, selectedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RectPainter oldDelegate) {
    return oldDelegate.horizontalDivision != horizontalDivision ||
        oldDelegate.verticalDivision != verticalDivision ||
        oldDelegate.selectedBoxes != selectedBoxes;
  }
}