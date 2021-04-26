import 'package:json_annotation/json_annotation.dart';

part 'Chapter.g.dart';

@JsonSerializable()
class Chapter {
  final String name;

  Chapter(this.name);

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}