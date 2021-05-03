part of '../../ProjectsPage.dart';

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => context.read<ProjectsBloc>().add(ProjectsEvents.searchTextChanged(value)),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: "Chercher un projet",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
