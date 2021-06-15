part of '../RunForm.dart';

class _LimitDateField extends StatelessWidget {
  final DateTime? initialValue;

  const _LimitDateField({Key? key, this.initialValue}) : super(key: key);

  void _onCheckBoxChanged(BuildContext context, bool? checked) {
    if (checked != null) {
      context.read<RunEditionBloc>().add(checked
          ? RunEditionEvents.limitDateChanged(DateTime.now().add(Duration(days: 30)))
          : RunEditionEvents.limitDateCleared());
    }
  }

  void _pickDate(BuildContext context, DateTime? currentValue) async {
    final DateTime? limitDate = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      currentTime: currentValue ?? DateTime.now(),
      locale: LocaleType.fr,
    );

    if (limitDate != null) {
      context.read<RunEditionBloc>().add(RunEditionEvents.limitDateChanged(limitDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunEditionBloc, RunEditionState>(
      buildWhen: (previous, current) => previous.limitDate != current.limitDate,
      builder: (context, state) => Row(
        children: [
          Checkbox(
            value: state.hasLimitDate,
            onChanged: (value) => _onCheckBoxChanged(context, value),
          ),
          Expanded(
            child: TextField(
              key: Key('runForm_limitDateField'),
              controller: TextEditingController(
                text: state.limitDate.value != null
                    ? DateFormat("dd/MM/yyyy HH:mm").format(state.limitDate.value!)
                    : "Pas de date limite",
              ),
              readOnly: true,
              enabled: state.hasLimitDate,
              onTap: () => _pickDate(context, state.limitDate.value),
              decoration: InputDecoration(
                labelText: 'Date limite',
                errorText: state.limitDate.invalid ? state.limitDate.error?.message : null,
                helperText: 'Le run sera considéré en retard une fois la date limite dépassée',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
