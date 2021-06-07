import 'package:flutter/material.dart';
import 'package:gobz_app/data/configurations/AppConfig.dart';
import 'package:gobz_app/data/configurations/GobzClientConfig.dart';
import 'package:gobz_app/view/GobzApp.dart';

void main() {
  AppConfig.create(AppConfig(
    gobzClientConfig: GobzClientConfig(
      host: "localhost:8080",
      logRequests: true,
    ),
  ));

  runApp(GobzApp());
}
