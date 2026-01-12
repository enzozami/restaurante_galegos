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

  @override
  Future<void> updateData(
    String? newWe,
    String? newPhilosophy,
    String? newWhyChooseUs,
    String? newBuffet,
    String? newService,
    String? newLunchboxes,
  ) async {
    await _aboutUsRepository.updateData(
      newWe,
      newPhilosophy,
      newWhyChooseUs,
      newBuffet,
      newService,
      newLunchboxes,
    );
    await getAboutUs();
  }
}
