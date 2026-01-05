import 'dart:convert';

class AboutUsModel {
  final String we;
  final String philosophy;
  final String whyChooseUs;
  final String buffet;
  final String service;
  final String lunchboxes;
  AboutUsModel({
    required this.we,
    required this.philosophy,
    required this.whyChooseUs,
    required this.buffet,
    required this.service,
    required this.lunchboxes,
  });

  Map<String, dynamic> toMap() {
    return {
      'we': we,
      'philosophy': philosophy,
      'whyChooseUs': whyChooseUs,
      'buffet': buffet,
      'service': service,
      'lunchboxes': lunchboxes,
    };
  }

  factory AboutUsModel.fromMap(Map<String, dynamic> map) {
    return AboutUsModel(
      we: map['we'] ?? '',
      philosophy: map['philosophy'] ?? '',
      whyChooseUs: map['whyChooseUs'] ?? '',
      buffet: map['buffet'] ?? '',
      service: map['service'] ?? '',
      lunchboxes: map['lunchboxes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutUsModel.fromJson(String source) => AboutUsModel.fromMap(json.decode(source));

  AboutUsModel copyWith({
    String? we,
    String? philosophy,
    String? whyChooseUs,
    String? buffet,
    String? service,
    String? lunchboxes,
  }) {
    return AboutUsModel(
      we: we ?? this.we,
      philosophy: philosophy ?? this.philosophy,
      whyChooseUs: whyChooseUs ?? this.whyChooseUs,
      buffet: buffet ?? this.buffet,
      service: service ?? this.service,
      lunchboxes: lunchboxes ?? this.lunchboxes,
    );
  }

  @override
  String toString() {
    return 'AboutUsModel(we: $we, philosophy: $philosophy, whyChooseUs: $whyChooseUs, buffet: $buffet, service: $service, lunchboxes: $lunchboxes)';
  }
}
