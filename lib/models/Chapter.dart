import 'package:json_annotation/json_annotation.dart';

part 'Chapter.g.dart';

@JsonSerializable()
class Chapter {
  final int id;
  final String name;
  final String description;
  final double? completion;

  Chapter(this.id, this.name, this.description, this.completion);

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}
