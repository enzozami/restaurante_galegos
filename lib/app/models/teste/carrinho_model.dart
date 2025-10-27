import 'dart:convert';
import 'package:restaurante_galegos/app/models/teste/item_carrinho_model.dart';

class CarrinhoModel {
  ItemCarrinhoModel item;
  int quantidadeItens;

  CarrinhoModel({
    required this.item,
    required this.quantidadeItens,
  });

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantidadeItens': quantidadeItens,
    };
  }

  factory CarrinhoModel.fromMap(Map<String, dynamic> map) {
    return CarrinhoModel(
      item: ItemCarrinhoModel.fromMap(map['item']),
      quantidadeItens: map['quantidadeItens']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarrinhoModel.fromJson(String source) => CarrinhoModel.fromMap(json.decode(source));
}
