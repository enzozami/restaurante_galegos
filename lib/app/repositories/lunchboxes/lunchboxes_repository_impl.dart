import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

import './lunchboxes_repository.dart';

class LunchboxesRepositoryImpl implements LunchboxesRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<FoodModel>> getFood() async {
    try {
      final snapshot = await firestore.collection('foods').get();
      final foods = snapshot.docs
          .map((doc) => FoodModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      return foods;
    } catch (e, s) {
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      throw Exception('Erro ao carregar marmitas');
    }
  }

  @override
  Future<List<MenuModel>> getMenu() async {
    final snapshot = await firestore.collection('menu').get();
    final menu = snapshot.docs
        .map((doc) => MenuModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
    return menu;
  }

  @override
  Future<FoodModel> cadastrarMarmita(FoodModel food) async {
    try {
      final query = await firestore
          .collection('foods')
          .orderBy('id', descending: true)
          .limit(1)
          .get();
      int newId;
      if (query.docs.isEmpty) {
        newId = 1;
      } else {
        final lastId = query.docs.first.data()['id'];
        newId = (lastId is String ? int.parse(lastId) : lastId) + 1;
      }
      final newDocData = {
        'id': newId,
        "name": food.name,
        "dayName": food.dayName,
        "temHoje": food.temHoje,
        "description": food.description,
        "pricePerSize": food.pricePerSize,
        "image": food.image,
      };

      await firestore.collection('foods').doc(newId.toString()).set(newDocData);
      return FoodModel.fromMap({...newDocData, 'id': newId});
    } catch (e, s) {
      log('Erro ao cadastrar marmita', error: e, stackTrace: s);
      throw Exception('Erro ao cadastrar marmita');
    }
  }

  @override
  Future<void> deletarMarmita(FoodModel food) async {
    try {
      await firestore.collection('foods').doc(food.id.toString()).delete();
    } catch (e, s) {
      log('Erro ao deletar marmita', error: e, stackTrace: s);
      throw Exception('Erro ao deletar marmita');
    }
  }

  @override
  Future<void> updateData(
    FoodModel food,
    String? newName,
    String? newDescription,
    List<String>? newDays,
    Map<String, double>? newPrices,
    bool? newTemHoje,
  ) async {
    try {
      final route = FirebaseFirestore.instance.collection('foods').doc(food.id.toString());

      if (newName != null) {
        await route.update({
          'name': newName,
        });
      }
      if (newDescription != null) {
        await route.update({
          'description': newDescription,
        });
      }
      if (newPrices != null) {
        await route.update({
          'pricePerSize': newPrices,
        });
      }
      if (newDays != null) {
        await route.update({
          'dayName': newDays,
        });
      }
      if (newTemHoje != null) {
        await route.update({
          'temHoje': newTemHoje,
        });
      }
    } catch (e, s) {
      log('Erro ao atualizar dados da marmita', error: e, stackTrace: s);
      throw Exception('Erro ao atualizar dados da marmita');
    }
  }
}
