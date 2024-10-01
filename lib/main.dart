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

  // Set untuk melacak kotak yang dipilih
  final Set<Offset> _selectedBoxes = {};

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
                          _selectedBoxes.clear(); // Reset saat slider berubah
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
                GestureDetector(
                  onTapDown: (details) {
                    _handleTap(details.localPosition);
                  },
                  child: CustomPaint(
                    size: const Size(280, 280),
                    painter: RectPainter(
                      horizontalDivision: _horizontalDivision,
                      verticalDivision: _verticalDivision,
                      selectedBoxes: _selectedBoxes,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  child: Slider(
                    thumbColor: const Color(0xff1C858B),
                    activeColor: const Color(0xff1C858B),
                    inactiveColor: const Color(0xff363636),
                    value: _horizontalDivision,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _horizontalDivision.toStringAsFixed(0),
                    onChanged: (newDivision) {
                      setState(() {
                        _horizontalDivision = newDivision;
                        _selectedBoxes.clear(); // Reset saat slider berubah
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Menampilkan jumlah kotak yang dipilih
                Text(
                  'Selected: ${_selectedBoxes.length} / ${(_horizontalDivision * _verticalDivision).toInt()}',
                  style: const TextStyle(color: Colors.white),
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

  void _handleTap(Offset position) {
    final double boxWidth = 280 / _horizontalDivision;
    final double boxHeight = 280 / _verticalDivision;

    // Hitung kotak mana yang dipilih berdasarkan posisi klik
    final int xIndex = (position.dx ~/ boxWidth);
    final int yIndex = (position.dy ~/ boxHeight);

    final selectedBox = Offset(xIndex.toDouble(), yIndex.toDouble());

    setState(() {
      // Toggle kotak apakah dipilih atau dihapus dari set
      if (_selectedBoxes.contains(selectedBox)) {
        _selectedBoxes.remove(selectedBox);
      } else {
        _selectedBoxes.add(selectedBox);
      }
    });
  }
}

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
