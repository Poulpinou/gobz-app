import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/ProjectInfos.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';
import 'package:intl/intl.dart';

class ProjectInfosModule extends StatelessWidget {
  final int projectId;
  final ProjectInfos? initialValue;

  const ProjectInfosModule({Key? key, required this.projectId, this.initialValue}) : super(key: key);

  factory ProjectInfosModule.fromProject(Project project) => ProjectInfosModule(
        projectId: project.id,
        initialValue: ProjectInfos.fromProject(project),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectInfos>(
        initialData: initialValue,
        future: context.read<ProjectRepository>().getProjectInfos(projectId),
        builder: (context, snapshot) {
          return SectionDisplay(
            title: 'Infos',
            icon: Icons.info,
            child: snapshot.hasError
                ? FetchFailure(message: "La récupération des infos a échoué")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.image,
                            size: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "General",
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data?.createdAt != null
                                    ? "Créé le ${DateFormat("dd/MM/yyyy à HH:mm").format(snapshot.data!.createdAt!)}"
                                    : "Chargement..."),
                                Text("Public: ${snapshot.data?.isShared ?? false ? 'oui' : 'non'}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data?.description ?? "Chargement...",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
