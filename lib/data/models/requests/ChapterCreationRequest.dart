import 'package:json_annotation/json_annotation.dart';

part 'ChapterCreationRequest.g.dart';

@JsonSerializable()
class ChapterCreationRequest {
  final String name;
  final String description;

  ChapterCreationRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() => _$ChapterCreationRequestToJson(this);
}
