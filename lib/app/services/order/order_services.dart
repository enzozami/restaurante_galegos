import 'package:restaurante_galegos/app/models/card_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho.dart';

abstract interface class OrderServices {
  Future<CardModel> createOrder(ItemCarrinho order);
}
