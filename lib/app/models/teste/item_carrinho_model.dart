import 'dart:convert';

import 'package:restaurante_galegos/app/models/teste/food_model.dart';
import 'package:restaurante_galegos/app/models/teste/product_model.dart';

class ItemCarrinhoModel {
  ProductModel? produto;
  FoodModel? alimento;
  int quantidade;
  String? tamanho;
  double? valorPorTamanho;

  ItemCarrinhoModel({
    this.produto,
    this.alimento,
    required this.quantidade,
    this.tamanho,
    this.valorPorTamanho,
  });

  Map<String, dynamic> toMap() {
    return {
      'produto': produto?.toMap(),
      'alimento': alimento?.toMap(),
      'quantidade': quantidade,
      'tamanho': tamanho,
      'valorPorTamanho': valorPorTamanho,
    };
  }

  factory ItemCarrinhoModel.fromMap(Map<String, dynamic> map) {
    return ItemCarrinhoModel(
      produto: map['produto'] != null ? ProductModel.fromMap(map['produto']) : null,
      alimento: map['alimento'] != null ? FoodModel.fromMap(map['alimento']) : null,
      quantidade: map['quantidade']?.toInt() ?? 0,
      tamanho: map['tamanho'],
      valorPorTamanho: map['valorPorTamanho']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCarrinhoModel.fromJson(String source) =>
      ItemCarrinhoModel.fromMap(json.decode(source));
}
