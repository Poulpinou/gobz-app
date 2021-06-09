import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/ProjectMember.dart';
import 'package:gobz_app/data/models/enums/ProjectRole.dart';
import 'package:gobz_app/view/widgets/generic/Avatar.dart';

class ProjectMemberItem extends StatelessWidget {
  final ProjectMember member;

  const ProjectMemberItem({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Avatar(
            member,
            size: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(member.name,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
            ),
          ),
          Text(
            member.role.displayName,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
