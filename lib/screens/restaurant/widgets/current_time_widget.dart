import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeWidget extends StatefulWidget {
  const CurrentTimeWidget({super.key});

  @override
  State<CurrentTimeWidget> createState() =>
      _CurrentTimeWidgetState();
}

class _CurrentTimeWidgetState
    extends State<CurrentTimeWidget> {

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();

    return Text(
      DateFormat(
        'dd/MM/yyyy   •   hh:mm a',
      ).format(now),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}