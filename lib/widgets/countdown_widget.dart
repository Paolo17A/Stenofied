import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/time_utils.dart';

class CountdownTimerWidget extends ConsumerStatefulWidget {
  final Duration startingDuration;
  final void Function(Duration) onCountdownTick;
  final void Function(Duration) onTimerTick;
  final void Function() onCountdownComplete;

  const CountdownTimerWidget({
    super.key,
    required this.startingDuration,
    required this.onCountdownTick,
    required this.onTimerTick,
    required this.onCountdownComplete,
  });

  @override
  CountdownTimerWidgetState createState() => CountdownTimerWidgetState();
}

class CountdownTimerWidgetState extends ConsumerState<CountdownTimerWidget> {
  Timer? _timer;
  Duration _elapsedTime = const Duration();

  @override
  void initState() {
    super.initState();
    _elapsedTime = widget.startingDuration;
    _startTimer();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      widget.onTimerTick(_elapsedTime);
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (ref.read(loadingProvider).isLoading) return;
      widget.onCountdownTick(_elapsedTime);
      setState(() {
        if (_elapsedTime.inSeconds > 0) {
          _elapsedTime = Duration(seconds: _elapsedTime.inSeconds - 1);
        } else {
          _timer?.cancel();
          widget.onCountdownComplete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.ketchup),
        padding: EdgeInsets.all(8),
        child: whiteAndadaProBold(
            'Remaining Time: ${printDuration(_elapsedTime)}',
            fontSize: 24));
  }
}
