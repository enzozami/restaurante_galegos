import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';

import './time_repository.dart';

class TimeRepositoryImpl implements TimeRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<TimeModel>> getTime() async {
    final snapshot = await firestore.collection('horario_funcionamento').get();
    return snapshot.docs.map((doc) => TimeModel.fromMap({...doc.data(), 'id': doc.id})).toList();
  }
}
