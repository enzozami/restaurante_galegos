import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class OrderModel {
  int userId;
  String address;
  List<ShoppingCardModel> items;

  OrderModel({
    required this.userId,
    required this.address,
    required this.items,
  });
}
