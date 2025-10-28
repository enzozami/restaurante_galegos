import 'package:restaurante_galegos/app/models/time_model.dart';

abstract interface class TimeRepository {
  Future<List<TimeModel>> getTime();
}
