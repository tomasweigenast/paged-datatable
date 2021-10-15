import 'dart:async';

import 'package:flutter/material.dart';

// A widget which rebuilds when timer is ticked.
class TimerBuilder extends StatefulWidget {
  final Duration duration;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const TimerBuilder({required this.duration, required this.builder, this.child, Key? key }) : super(key: key);

  @override
  _TimerBuilderState createState() => _TimerBuilderState();
}

class _TimerBuilderState extends State<TimerBuilder> {

  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.duration, (_) { 
      if(mounted) {
        Future.delayed(Duration.zero, () {
          setState((){});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}