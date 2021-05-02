import 'package:flutter/material.dart';
import 'package:gobz_app/configurations/AppConfig.dart';
import 'package:gobz_app/configurations/GobzClientConfig.dart';
import 'package:gobz_app/widgets/GobzApp.dart';

void main() {
  AppConfig.create(AppConfig(
    gobzClientConfig:
        GobzClientConfig(host: "localhost:8080", logRequests: true),
  ));

  runApp(GobzApp());
}
