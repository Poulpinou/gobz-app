import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/runs/RunBloc.dart';
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/lists/items/RunListItem.dart';

class RunListItemComponent extends StatelessWidget {
  final Run _initialData;

  const RunListItemComponent({Key? key, required Run run})
      : _initialData = run,
        super(key: key);

  void _refreshRun(BuildContext context) {
    context.read<RunBloc>().add(RunEvents.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunBloc>(
      create: (context) => RunBloc(context.read<RunRepository>(), _initialData),
      child: BlocHandler<RunBloc, RunState>.simple(
        child: BlocBuilder<RunBloc, RunState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RunListItem(
                  run: state.run,
                  actions: [
                    PopupMenuItem(
                      child: const Text("Actualiser"),
                      value: () => _refreshRun(context),
                    ),
                  ],
                ),
                state.isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Synchronisation..."),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
