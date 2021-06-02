import 'package:json_annotation/json_annotation.dart';

part 'Step.g.dart';

@JsonSerializable()
class Step {
  final int id;
  final String name;
  final String description;
  final double? completion;

  Step(this.id, this.name, this.description, this.completion);

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
}
