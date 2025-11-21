import 'dart:convert';

import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';

class CarrinhoModel {
  ItemCarrinhoModel item;
  CarrinhoModel({required this.item});

  Map<String, dynamic> toMap() {
    return {'item': item.toMap()};
  }

  factory CarrinhoModel.fromMap(Map<String, dynamic> map) {
    final itemMap = map['item'];

    return CarrinhoModel(
      item: itemMap is Map<String, dynamic>
          ? ItemCarrinhoModel.fromMap(itemMap)
          : ItemCarrinhoModel(quantidade: 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory CarrinhoModel.fromJson(String source) => CarrinhoModel.fromMap(json.decode(source));

  CarrinhoModel copyWith({ItemCarrinhoModel? item}) {
    return CarrinhoModel(item: item ?? this.item);
  }
}
