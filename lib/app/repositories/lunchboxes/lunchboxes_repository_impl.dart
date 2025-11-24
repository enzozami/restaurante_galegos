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
  Future<void> updateTemHoje(int id, FoodModel food, bool novoValor) async {
    try {
      await firestore.collection('foods').doc(id.toString()).update({'temHoje': novoValor});
    } catch (e, s) {
      log('Erro ao atualizar temHoje [alimentos]', error: e, stackTrace: s);
      throw Exception('Erro ao atualizar temHoje [alimentos]');
    }
  }

  @override
  Future<FoodModel> cadastrarMarmita(FoodModel food) async {
    try {
      final docRef = await firestore.collection('foods').add({
        "name": food.name,
        "dayName": food.dayName,
        "temHoje": food.temHoje,
        "description": food.description,
        "pricePerSize": food.pricePerSize,
        "image": food.image,
      });
      final snapshot = await docRef.get();
      return FoodModel.fromMap({...snapshot.data()!, 'id': snapshot.id});
    } catch (e, s) {
      log('Erro ao cadastrar marmita', error: e, stackTrace: s);
      throw Exception('Erro ao cadastrar marmita');
    }
  }
}
