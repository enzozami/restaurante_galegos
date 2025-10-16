import 'dart:convert';

import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class OrderFinished {
  int id;
  List<ShoppingCardModel> productsSelected;
  OrderFinished({
    required this.id,
    required this.productsSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productsSelected': productsSelected.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderFinished.fromMap(Map<String, dynamic> map) {
    return OrderFinished(
      id: map['id']?.toInt() ?? 0,
      productsSelected: List<ShoppingCardModel>.from(
          map['productsSelected']?.map((x) => ShoppingCardModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderFinished.fromJson(String source) => OrderFinished.fromMap(json.decode(source));
}
