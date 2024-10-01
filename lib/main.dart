import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _horizontalDivision = 1.0;
  double _verticalDivision = 1.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xff363636),
        appBar: AppBar(
          title: const Text('Flutter Canvas'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      thumbColor: const Color(0xff1C858B),
                      activeColor: const Color(0xff1C858B),
                      inactiveColor: const Color(0xff363636),
                      value: _verticalDivision,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _verticalDivision.toStringAsFixed(0),
                      onChanged: (newDivision) {
                        setState(() {
                          _verticalDivision = newDivision;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(280, 280),
                  painter: RectPainter(
                      horizontalDivision: _horizontalDivision,
                      verticalDivision: _verticalDivision),
                ),
                const SizedBox(height: 20),
                // Slider untuk mengubah nilai pembagian kotak
                SizedBox(
                  width: 280,
                  child: Slider(
                    thumbColor: const Color(0xff1C858B),
                    activeColor: const Color(0xff1C858B),
                    inactiveColor: const Color(0xff363636),
                    value: _horizontalDivision,
                    min: 1,
                    max: 10,
                    divisions:
                        9, // Slider terbagi ke dalam 9 langkah (1 hingga 10)
                    label: _horizontalDivision.toStringAsFixed(0),
                    onChanged: (newDivision) {
                      setState(() {
                        _horizontalDivision =
                            newDivision; // Ubah nilai sesuai dengan slider
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 48,
            ),
          ],
        ),
      ),
    );
  }
}

class RectPainter extends CustomPainter {
  final double horizontalDivision;
  final double verticalDivision;

  RectPainter(
      {required this.horizontalDivision, required this.verticalDivision});

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

    final double boxWidth = size.width;
    final double boxHeight = size.height;

    // Gambar kotak utama
    final rect = Rect.fromLTWH(0, 0, boxWidth, boxHeight);
    canvas.drawRect(rect, paintRect);

    // Gambar garis vertikal sesuai dengan nilai horizontalDivision
    double divisionWidth = boxWidth / horizontalDivision;
    for (int i = 1; i < horizontalDivision; i++) {
      canvas.drawLine(Offset(divisionWidth * i, 0),
          Offset(divisionWidth * i, boxHeight), paint);
    }

    // Gambar garis horizontal sesuai dengan nilai verticalDivision
    double divisionHeight = boxHeight / verticalDivision;
    for (int i = 1; i < verticalDivision; i++) {
      canvas.drawLine(Offset(0, divisionHeight * i),
          Offset(boxWidth, divisionHeight * i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant RectPainter oldDelegate) {
    return oldDelegate.horizontalDivision != horizontalDivision ||
        oldDelegate.verticalDivision != verticalDivision;
  }
}

class CanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Warna gambar
      ..strokeWidth = 4.0 // Lebar garis
      ..style = PaintingStyle.stroke; // Hanya garis tepi, tanpa isi

    // Gambar garis dari titik (50, 50) ke titik (250, 250)
    canvas.drawLine(const Offset(50, 50), const Offset(50, 180), paint);

    // Gambar persegi panjang
    const rect = Rect.fromLTWH(50, 100, 200, 100); // x, y, lebar, tinggi
    canvas.drawRect(rect, paint);

    // Gambar lingkaran
    canvas.drawCircle(
        const Offset(150, 250), 50, paint); // Pusat di (150, 250), radius 50
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
