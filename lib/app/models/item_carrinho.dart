import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ItemCarrinho {
  int userId;
  String address;
  List<ShoppingCardModel> items;
  int quantity;

  ItemCarrinho({
    required this.userId,
    required this.address,
    required this.items,
    required this.quantity,
  });
}
