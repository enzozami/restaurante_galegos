import 'package:restaurante_galegos/app/models/time_model.dart';

abstract interface class TimeServices {
  Future<List<TimeModel>> getTime();
}
