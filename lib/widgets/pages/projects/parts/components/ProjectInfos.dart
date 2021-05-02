part of '../../ProjectPage.dart';

class _ProjectInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => _ProjectSectionDisplay(
        title: 'Infos',
        icon: Icons.info,
        child: Column(
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                          "Créé le ${DateFormat.yMd().format(state.project.createdAt)} à ${DateFormat.jm().format(state.project.createdAt)}"),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Description",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              state.project.description,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
