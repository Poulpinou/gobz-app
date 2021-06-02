import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/runs/RunsBloc.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/lists/RunList.dart';

import 'RunListItemComponent.dart';

class RunListComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunsBloc>(
      create: (context) => RunsBloc(context.read<RunRepository>(), fetchOnStart: true),
      child: BlocHandler<RunsBloc, RunsState>.simple(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).secondaryHeaderColor,
                    height: 40,
                    child: Text("TODO: Filters"),
                  ),
                )
              ],
            ),
            Expanded(
              child: BlocBuilder<RunsBloc, RunsState>(
                buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Chargement des runs..."),
                          Container(height: 10),
                          LinearProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  if (state.isErrored) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Impossible de récupérer les runs"),
                          ElevatedButton(
                              onPressed: () => context.read<RunsBloc>().add(RunsEvents.fetch()),
                              child: const Text("Réessayer"))
                        ],
                      ),
                    );
                  }

                  return RunList(
                    itemBuilder: (context, run) => RunListItemComponent(run: run),
                    runs: state.runs,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
