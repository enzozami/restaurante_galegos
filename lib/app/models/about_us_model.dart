import 'dart:convert';

class AboutUsModel {
  final String title;
  final String text;

  AboutUsModel({
    required this.title,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
    };
  }

  factory AboutUsModel.fromMap(Map<String, dynamic> map) {
    return AboutUsModel(
      title: map['title'] ?? '',
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutUsModel.fromJson(String source) => AboutUsModel.fromMap(json.decode(source));
}
