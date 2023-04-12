import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitor/widgets/screen_widget.dart';

class Clock extends StatefulWidget {
  final bool is24H;
  final double fontSize;
  const Clock({required this.is24H, required this.fontSize, super.key});

  @override
  State<StatefulWidget> createState() => ClockState();
}

class ClockState extends State<Clock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateFormat.EEEE().format(_now), style: TextStyle(fontSize: widget.fontSize),),
          Text(DateFormat.MMMMd().format(_now), style: TextStyle(fontSize: widget.fontSize),),
          Text(widget.is24H ? DateFormat.Hm().format(_now) : DateFormat.jm().format(_now),
            style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}

class TimeSW extends ScreenWidget {
  bool is24H;
  double fontSize;

  TimeSW({this.is24H = false, this.fontSize = 60.0});

  get widget {
    return Clock(is24H: is24H, fontSize: fontSize,);
  }
  
  @override
  Widget get editWidget {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: const [
        Icon(Icons.watch),
        Text('Time')
      ],
    );
  }
}