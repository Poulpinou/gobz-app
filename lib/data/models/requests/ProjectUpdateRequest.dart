import 'package:json_annotation/json_annotation.dart';

part 'ProjectUpdateRequest.g.dart';

@JsonSerializable()
class ProjectUpdateRequest {
  final String name;
  final String description;
  final bool shared;

  ProjectUpdateRequest(this.name, this.description, this.shared);

  Map<String, dynamic> toJson() => _$ProjectUpdateRequestToJson(this);
}
