import 'dart:convert';

class LocalInfo {
  final id;
  final title;
  List info;

  LocalInfo(
    this.id,
    this.title,
    this.info,
  );

  factory LocalInfo.fromJson(Map<String, dynamic> json) {
    return LocalInfo(json['_id'], json['title'], json['info']);
  }
}
