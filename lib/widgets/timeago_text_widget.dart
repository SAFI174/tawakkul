import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgoWidget extends StatefulWidget {
  final DateTime targetDate;

  const TimeAgoWidget({
    Key? key,
    required this.targetDate,
  }) : super(key: key);

  @override
  TimeAgoWidgetState createState() => TimeAgoWidgetState();
}

class TimeAgoWidgetState extends State<TimeAgoWidget> {
  late Timer _timer;
  late String _timeAgo;

  @override
  void initState() {
    super.initState();
    _updateTimeAgo();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeAgo();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeAgo() {
    setState(() {
      _timeAgo = timeago.format(
        widget.targetDate,
        locale: 'ar',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AutoSizeText(
      _timeAgo,
      style: theme.textTheme.labelMedium,
    );
  }
}
