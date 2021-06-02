import 'package:json_annotation/json_annotation.dart';

part 'ChapterUpdateRequest.g.dart';

@JsonSerializable()
class ChapterUpdateRequest {
  final String name;
  final String description;

  ChapterUpdateRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() => _$ChapterUpdateRequestToJson(this);
}
