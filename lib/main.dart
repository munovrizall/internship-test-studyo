import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:internship_test_studyo/utils/constants.dart';
import 'package:internship_test_studyo/widgets/rect_painter.dart';

enum Orientation { vertical, horizontal }

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _horizontalDivision = 1.0;
  double _verticalDivision = 1.0;

  final Set<Offset> _selectedBoxes = {};

  int _numerator = 1;
  int _denominator = 1;

  int correctAnswer = 0;
  final int _targetCorrectAnswers = 5;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.darkGrey,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 32,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        _generateNewQuestion();
                      },
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 36,
                      color: Colors.green,
                    ),
                    Icon(
                      Icons.star,
                      size: 36,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 48,
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: LinearProgressIndicator(
                  value: progress, // Nilai progress bar
                  backgroundColor: AppColors.grey,
                  color: Colors.green,
                  minHeight: 10,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sliderWidget(Orientation.vertical),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$_numerator',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 40,
                            child: Divider(
                              color: Colors.white,
                              thickness: 5,
                            ),
                          ),
                          Text(
                            '$_denominator',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36),
                          ),
                        ],
                      ),
                      sliderWidget(Orientation.horizontal),
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
                      sliderWidget(Orientation.horizontal),
                      const SizedBox(height: 20),
                      // Hiding this text, because the selectedbox state won't be updated if i remove this text
                      Opacity(
                        opacity: 0,
                        child: Text(
                          'Selected: ${_selectedBoxes.length} / ${(_horizontalDivision * _verticalDivision).toInt()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: FilledButton(
                          onPressed: _checkAnswer,
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.darkGrey,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 32,
                            color: Color.fromARGB(255, 16, 197, 43),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sliderWidget(Orientation.vertical),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  SizedBox sliderWidget(Orientation orientation) {
    if (orientation == Orientation.vertical) {
      return SizedBox(
        height: 280,
        child: RotatedBox(
          quarterTurns: 1,
          child: Slider(
            thumbColor: AppColors.primaryBlue,
            activeColor: AppColors.primaryBlue,
            inactiveColor: AppColors.backgroundColor,
            value: _verticalDivision,
            min: 1,
            max: 10,
            divisions: 9,
            label: _verticalDivision.toStringAsFixed(0),
            onChanged: (newDivision) {
              setState(() {
                _verticalDivision = newDivision;
                _selectedBoxes.clear();
              });
            },
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 280,
        child: Slider(
          thumbColor: AppColors.primaryBlue,
          activeColor: AppColors.primaryBlue,
          inactiveColor: const Color(0xff363636),
          value: _horizontalDivision,
          min: 1,
          max: 10,
          divisions: 9,
          label: _horizontalDivision.toStringAsFixed(0),
          onChanged: (newDivision) {
            setState(() {
              _horizontalDivision = newDivision;
              _selectedBoxes.clear();
            });
          },
        ),
      );
    }
  }

  void _handleTap(Offset position) {
    final double boxWidth = 280 / _horizontalDivision;
    final double boxHeight = 280 / _verticalDivision;

    final int xIndex = (position.dx ~/ boxWidth);
    final int yIndex = (position.dy ~/ boxHeight);

    final selectedBox = Offset(xIndex.toDouble(), yIndex.toDouble());

    setState(() {
      if (_selectedBoxes.contains(selectedBox)) {
        _selectedBoxes.remove(selectedBox);
      } else {
        _selectedBoxes.add(selectedBox);
      }
    });
  }

  void _generateNewQuestion() {
    List<int> possibilities = [];

    for (int i = 1; i <= 10; i++) {
      for (int j = 1; j <= 10; j++) {
        possibilities.add(i * j);
      }
    }
    possibilities = possibilities.toSet().toList();

    int randomDenominator =
        possibilities[Random().nextInt(possibilities.length)];

    int randomNumerator;

    do {
      randomNumerator = Random().nextInt(99) + 2;
    } while (randomNumerator >= randomDenominator);

    setState(() {
      _denominator = randomDenominator;
      _numerator = randomNumerator;
    });
  }

  void _checkAnswer() {
    if (_selectedBoxes.length == _numerator) {
      _showToast("Correct answer!", Colors.green);
      correctAnswer++;
      _updateProgress();

      if (correctAnswer == 5) {
        _showCompletionDialog();
      } else {
        _generateNewQuestion();
        _selectedBoxes.clear();
      }
    } else {
      _showToast("Wrong answer!", Colors.red);
      _generateNewQuestion();
      _selectedBoxes.clear();
    }
  }

  void _updateProgress() {
    setState(() {
      progress = correctAnswer / _targetCorrectAnswers;
    });
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have finished the game!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                correctAnswer = 0; // Reset jawaban benar
                progress = 0.0; // Reset progress bar
                _generateNewQuestion(); // Generate soal baru
                _selectedBoxes.clear(); // Clear selected boxes
              });
            },
            child: const Text('Play again'),
          ),
        ],
      ),
    );
  }
}
