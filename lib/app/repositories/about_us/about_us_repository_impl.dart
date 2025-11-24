import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/about_us_model.dart';

import './about_us_repository.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<AboutUsModel> getAboutUs() async {
    final snapshot = await firestore.collection('sobre_nos').get();
    final doc = snapshot.docs.first;
    return AboutUsModel.fromMap({...doc.data(), 'id': doc.id});
  }
}
