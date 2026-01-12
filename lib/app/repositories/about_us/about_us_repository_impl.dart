import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/about_us_model.dart';

import './about_us_repository.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  final firestore = FirebaseFirestore.instance;

  @override
  Future<AboutUsModel> getAboutUs() async {
    final snapshot = await firestore.collection('sobre_nos').get();
    final doc = snapshot.docs.first;
    return AboutUsModel.fromMap({...doc.data(), 'id': doc.id});
  }

  @override
  Future<void> updateData(
    String? newWe,
    String? newPhilosophy,
    String? newWhyChooseUs,
    String? newBuffet,
    String? newService,
    String? newLunchboxes,
  ) async {
    try {
      final snapshot = await firestore.collection('sobre_nos').get();
      final doc = snapshot.docs.first;
      final route = firestore.collection('sobre_nos').doc(doc.id);

      if (newWe != null) {
        route.update({'we': newWe});
      }
      if (newPhilosophy != null) {
        route.update({'philosophy': newPhilosophy});
      }
      if (newWhyChooseUs != null) {
        route.update({'whyChooseUs': newWhyChooseUs});
      }
      if (newBuffet != null) {
        route.update({'buffet': newBuffet});
      }
      if (newService != null) {
        route.update({'service': newService});
      }
      if (newLunchboxes != null) {
        route.update({'lunchboxes': newLunchboxes});
      }
    } catch (e, s) {
      log('Erro ao atualizar dados do produto', error: e, stackTrace: s);
      throw Exception('Erro ao atualizar dados do produto');
    }
  }
}
