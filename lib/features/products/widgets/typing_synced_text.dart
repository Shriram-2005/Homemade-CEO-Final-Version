import 'dart:async';
import 'package:flutter/material.dart';

class TypingSyncedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration typingSpeed;
  final Duration deletingSpeed;

  const TypingSyncedText({
    super.key,
    required this.text,
    required this.style,
    this.typingSpeed = const Duration(milliseconds: 50),
    this.deletingSpeed = const Duration(milliseconds: 30),
  });

  @override
  State<TypingSyncedText> createState() => _TypingSyncedTextState();
}

class _TypingSyncedTextState extends State<TypingSyncedText> {
  String _displayedText = "";
  String _targetText = "";
  Timer? _timer;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _targetText = widget.text;
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TypingSyncedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _targetText = widget.text;
      setState(() {
        _displayedText = ""; // Clear instantly
      });
      _startTyping();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer?.cancel();
    int index = 0;
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (index < _targetText.length) {
        setState(() {
          _displayedText += _targetText[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText + (_isDeleting || _timer?.isActive == true ? "|" : ""),
      style: widget.style,
      softWrap: true,
    );
  }
}
