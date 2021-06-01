import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RunStatus { ACTIVE, LATE, ABANDONED, DONE }

extension RunStatusExtensions on RunStatus {
  Color get displayColor {
    switch (this) {
      case RunStatus.ACTIVE:
        return Colors.blueAccent;
      case RunStatus.LATE:
        return Colors.orangeAccent;
      case RunStatus.ABANDONED:
        return Colors.grey;
      case RunStatus.DONE:
        return Colors.greenAccent;
    }
  }

  String get name => this.toString().split('.').last;
}
