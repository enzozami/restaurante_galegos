import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLunchboxesController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void cadastrarNovasMarmitas() {
    // if (addDays.isEmpty) {
    //   _message(
    //     MessageModel(
    //       title: 'Atenção',
    //       message: 'Selecione ao menos um dia para cadastrar.',
    //       type: MessageType.error,
    //     ),
    //   );
    //   return;
    // }
    // if (!validateForm()) return;
    // _foodService.cadastrarMarmita(
    //   nomeMarmitaEC.text,
    //   addDays,
    //   descricaoEC.text,
    //   {
    //     'mini': double.parse(
    //       precoMiniEC.text.replaceAll('.', '').replaceAll(',', '.'),
    //     ),
    //     'media': double.parse(
    //       precoMediaEC.text.replaceAll('.', '').replaceAll(',', '.'),
    //     ),
    //   },
    // );
    // nomeMarmitaEC.clear();
    // descricaoEC.clear();
    // precoMiniEC.clear();
    // precoMediaEC.clear();
    // addDays.clear();
    // refreshLunchboxes();
    Get.back();
  }
}
