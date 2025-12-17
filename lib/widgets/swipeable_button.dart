import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwipeableButton extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  const SwipeableButton({super.key, required this.onSwipeComplete});

  @override
  State<SwipeableButton> createState() => _SwipeableButtonState();
}

class _SwipeableButtonState extends State<SwipeableButton> {
  final double _buttonWidth = 200.0;
  final double _buttonHeight = 60.0;
  final double _padding = 4.0;

  double _dragValue = 0.0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _resetButton();
  }

  void _resetButton() {
    _dragValue = 0.0;
    _isFinished = false;
  }

  @override
  Widget build(BuildContext context) {
    final double maxDrag =
        _buttonWidth - (_buttonHeight - _padding * 2) - _padding;

    return Container(
      width: _buttonWidth,
      height: _buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFFF987C),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Opacity(
                opacity: 1 - (_dragValue / maxDrag).clamp(0.0, 1.0),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.alice(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: _padding + _dragValue,
            top: _padding,
            bottom: _padding,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (_isFinished) return;
                setState(() {
                  _dragValue += details.delta.dx;
                  _dragValue = _dragValue.clamp(0.0, maxDrag);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_isFinished) return;
                if (_dragValue > maxDrag * 0.7) {
                  setState(() {
                    _dragValue = maxDrag;
                    _isFinished = true;
                  });
                  widget.onSwipeComplete();
                } else {
                  setState(() {
                    _dragValue = 0.0;
                  });
                }
              },
              child: Container(
                width: _buttonHeight - _padding * 2,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
