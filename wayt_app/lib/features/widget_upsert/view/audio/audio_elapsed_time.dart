import 'dart:async';

import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

/// A widget that displays the elapsed time.
class AudioElapsedTime extends StatefulWidget {
  /// Creates a new instance of [AudioElapsedTime].
  const AudioElapsedTime({super.key});

  @override
  State<StatefulWidget> createState() => _AudioElapsedTimeState();
}

class _AudioElapsedTimeState extends State<AudioElapsedTime> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        setState(() {});
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
    final d = Duration(milliseconds: _timer.tick * 10);
    return Text(
      d.toHhMmSsMmmString(),
      style: context.tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      textScaler: TextScaler.noScaling,
    );
  }
}
