import 'package:restaurante_galegos/app/models/about_us_model.dart';
import 'package:restaurante_galegos/app/repositories/about_us/about_us_repository.dart';

import './about_us_services.dart';

class AboutUsServicesImpl implements AboutUsServices {
  final AboutUsRepository _aboutUsRepository;

  AboutUsServicesImpl({
    required AboutUsRepository aboutUsRepository,
  }) : _aboutUsRepository = aboutUsRepository;

  @override
  Future<AboutUsModel> getAboutUs() => _aboutUsRepository.getAboutUs();
}
