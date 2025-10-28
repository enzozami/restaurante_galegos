import 'package:restaurante_galegos/app/models/about_us_model.dart';

abstract interface class AboutUsServices {
  Future<AboutUsModel> getAboutUs();
}
