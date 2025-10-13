import 'dart:convert';

class PricePerSizeModel {
  final String tamanho;
  PricePerSizeModel({
    required this.tamanho,
  });

  Map<String, dynamic> toMap() {
    return {
      'tamanho': tamanho,
    };
  }

  factory PricePerSizeModel.fromMap(Map<String, dynamic> map) {
    return PricePerSizeModel(
      tamanho: map['tamanho'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PricePerSizeModel.fromJson(String source) =>
      PricePerSizeModel.fromMap(json.decode(source));
}
