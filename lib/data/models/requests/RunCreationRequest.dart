import 'package:json_annotation/json_annotation.dart';

part 'RunCreationRequest.g.dart';

@JsonSerializable()
class RunCreationRequest {
  final int stepId;
  final List<int> taskIds;
  final DateTime? limitDate;

  RunCreationRequest(this.stepId, this.taskIds, this.limitDate);

  Map<String, dynamic> toJson() => _$RunCreationRequestToJson(this);
}
