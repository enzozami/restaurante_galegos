import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsServices {
  Future<List<ProductModel>> getProducts();
}
