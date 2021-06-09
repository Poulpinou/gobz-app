import 'package:flutter/material.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';

class ProjectResourcesModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionDisplay(
      title: 'Ressources',
      icon: Icons.storage,
      child: const Text("Arrive bientôt!"),
    );
  }
}
