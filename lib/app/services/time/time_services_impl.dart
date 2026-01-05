import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';

import './time_services.dart';

class TimeServicesImpl implements TimeServices {
  final TimeRepository _timeRepository;
  final _firebase = FirebaseFirestore.instance;

  TimeServicesImpl({required TimeRepository timeRepository}) : _timeRepository = timeRepository;

  @override
  Future<List<TimeModel>> getTime() => _timeRepository.getTime();

  @override
  Future<bool> openOrClosedRestaurant() async {
    final now = DateTime.now();

    final snapshot = await _firebase.collection('horario_funcionamento').get();
    if (snapshot.docs.isEmpty) return false;

    final horariosApi = snapshot.docs.first.data();

    final horasCelular = (now.hour * 100) + now.minute;

    final inicio = formatarHorarioApi(horariosApi['inicio']);
    final fim = formatarHorarioApi(horariosApi['fim']);

    return horasCelular >= inicio && horasCelular <= fim;
  }

  int formatarHorarioApi(String? hhmm) {
    if (hhmm == null) return 0;
    return int.parse(hhmm.replaceAll(':', ''));
  }
}
