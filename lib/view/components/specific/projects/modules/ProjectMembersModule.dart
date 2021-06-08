import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/models/ProjectMember.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';
import 'package:gobz_app/view/widgets/lists/items/ProjectMemberItem.dart';

class ProjectMembersModule extends StatelessWidget {
  final int projectId;

  const ProjectMembersModule({Key? key, required this.projectId}) : super(key: key);

  Widget _buildBody(BuildContext context, AsyncSnapshot<List<ProjectMember>> snapshot) {
    if (snapshot.hasError) {
      return FetchFailure(message: "La récupération des membres a échoué");
    }

    if (snapshot.connectionState != ConnectionState.done) {
      return CircularLoader("Chargement des membres...");
    }

    final List<ProjectMember> members = snapshot.data!;

    return Container(
      constraints: BoxConstraints(minHeight: 0, maxHeight: 200),
      child: ListView(
        shrinkWrap: true,
        children: [
          ...List.generate(
            members.length,
            (index) => ProjectMemberItem(member: members[index]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProjectMember>>(
      future: context.read<ProjectRepository>().getProjectMembers(projectId),
      builder: (context, snapshot) => SectionDisplay(
        title: 'Membres',
        icon: Icons.group,
        child: _buildBody(context, snapshot),
        action: TextButton(
          child: Text("Gérer"),
          onPressed: null,
        ),
      ),
    );
  }
}
