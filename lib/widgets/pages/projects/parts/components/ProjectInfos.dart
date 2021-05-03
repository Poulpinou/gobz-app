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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text("Créé le ${DateFormat("dd/MM/yyyy à hh:mm").format(state.project.createdAt)}"),
                      Text("Public: ${state.project.isShared ? 'oui' : 'non'}"),
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
                    state.project.description,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
