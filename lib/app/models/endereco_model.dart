import 'dart:convert';

class EnderecoModel {
  String cep;
  String rua;
  String bairro;
  String cidade;
  String estado;
  int numeroResidencia;
  EnderecoModel({
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numeroResidencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'numeroResidencia': numeroResidencia,
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      cep: map['cep'] ?? '',
      rua: map['rua'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      numeroResidencia: map['numeroResidencia']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String source) => EnderecoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnderecoModel(cep: $cep, rua: $rua, bairro: $bairro, cidade: $cidade, estado: $estado, numeroResidencia: $numeroResidencia)';
  }

  EnderecoModel copyWith({
    String? cep,
    String? rua,
    String? bairro,
    String? cidade,
    String? estado,
    int? numeroResidencia,
  }) {
    return EnderecoModel(
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      numeroResidencia: numeroResidencia ?? this.numeroResidencia,
    );
  }
}
