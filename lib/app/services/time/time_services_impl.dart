import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';

import './time_services.dart';

class TimeServicesImpl implements TimeServices {
  final TimeRepository _timeRepository;

  TimeServicesImpl({required TimeRepository timeRepository}) : _timeRepository = timeRepository;

  @override
  Future<List<TimeModel>> getTime() => _timeRepository.getTime();
}
