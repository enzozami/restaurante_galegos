import 'dart:convert';

class CepModel {
  List<String> ceps;
  double taxa;

  CepModel({
    required this.ceps,
    required this.taxa,
  });

  Map<String, dynamic> toMap() {
    return {
      'ceps': ceps,
      'taxa': taxa,
    };
  }

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      ceps: List<String>.from(map['ceps'] ?? const []),
      taxa: map['taxa']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CepModel.fromJson(String source) => CepModel.fromMap(json.decode(source));
}
