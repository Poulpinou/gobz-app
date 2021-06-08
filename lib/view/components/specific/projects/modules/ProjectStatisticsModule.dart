import 'package:flutter/material.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';

class ProjectStatisticsModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionDisplay(
      title: 'Statistiques',
      icon: Icons.bar_chart,
      child: const Text("Arrive bientôt!"),
    );
  }
}
