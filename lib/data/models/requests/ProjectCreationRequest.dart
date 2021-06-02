import 'package:json_annotation/json_annotation.dart';

part 'ProjectCreationRequest.g.dart';

@JsonSerializable()
class ProjectCreationRequest {
  final String name;
  final String description;
  final bool shared;

  ProjectCreationRequest(this.name, this.description, this.shared);

  Map<String, dynamic> toJson() => _$ProjectCreationRequestToJson(this);
}
