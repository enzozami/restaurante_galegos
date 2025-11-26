import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection('products').get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      return products;
    } catch (e, s) {
      log('Erro ao carregar produtos', error: e, stackTrace: s);
      throw Exception('Erro ao carregar produtos');
    }
  }

  @override
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor) async {
    try {
      await firestore.collection('products').doc(id.toString()).update({'temHoje': novoValor});
    } catch (e, s) {
      log('Erro ao atualizar temHoje [produtos]', error: e, stackTrace: s);
      throw Exception('Erro ao atualizar temHoje [produtos]');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore.collection('categories').get();
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      return categories;
    } catch (e, s) {
      log('Erro ao carregar categorias', error: e, stackTrace: s);
      throw Exception('Erro ao carregar categorias');
    }
  }

  @override
  Future<ProductModel> cadastrarProdutos(ProductModel item) async {
    try {
      final query = await firestore
          .collection('products')
          .orderBy('id', descending: true)
          .limit(1)
          .get();
      int newId;
      if (query.docs.isEmpty) {
        newId = 1;
      } else {
        final lastId = query.docs.first.data()['id'];
        newId = (lastId as int) + 1;
      }
      final newDocData = {
        'id': newId,
        'categoryId': item.categoryId,
        'name': item.name,
        'description': item.description ?? '',
        'temHoje': item.temHoje,
        'price': item.price,
      };

      await firestore.collection('products').doc(newId.toString()).set(newDocData);

      return ProductModel.fromMap({...newDocData, 'id': newId});
    } catch (e, s) {
      log('Erro ao cadastrar produto', error: e, stackTrace: s);
      throw Exception('Erro ao cadastrar produto');
    }
  }

  @override
  Future<void> deletarProdutos(ProductModel item) async {
    try {
      await firestore.collection('products').doc(item.id.toString()).delete();
    } catch (e, s) {
      log('Erro ao cadastrar produto', error: e, stackTrace: s);
      throw Exception('Erro ao deletar produto');
    }
  }
}
