import 'package:get/get.dart';

class FinishOrderController extends GetxController {
  // Future<bool> createOrder() async {
  //   if (isProcessing.value) return false;
  //   _loading.value = true;
  //   log('Status do loading INICIAL: ${loading.value}');
  //   isProcessing.value = true;
  //   bool sucesso = false;
  //   try {
  //     if (!validateForm()) {
  //       _message(
  //         MessageModel(
  //           title: 'Erro',
  //           message: 'Preencha todos os campos',
  //           type: MessageType.error,
  //         ),
  //       );
  //       return false;
  //     }

  //     final user = _authServices.getUserId();
  //     final name = _authServices.getUserName();
  //     final id = await _orderServices.generateSequentialOrderId();
  //     quantityRx.value = products.fold<int>(0, (sum, e) => sum + e.item.quantidade);

  //     final numero = int.tryParse(numeroEC.text);
  //     if (numero == null) {
  //       _message(
  //         MessageModel(
  //           title: 'Erro',
  //           message: 'Número da residência inválido',
  //           type: MessageType.error,
  //         ),
  //       );
  //       return false;
  //     }

  //     log('FORMULÁRIO VALIDADO');
  //     final order = PedidoModel(
  //       id: id,
  //       userId: user!,
  //       cep: cepFormatter.getUnmaskedText(),
  //       rua: rua.value,
  //       bairro: bairro.value,
  //       cidade: cidade.value,
  //       estado: estado.value,
  //       numeroResidencia: numero,
  //       cart: _carrinhoServices.itensCarrinho,
  //       amountToPay: totalPay(taxa.value)!,
  //       taxa: taxa.value,
  //       status: 'preparando',
  //       userName: name ?? '',
  //       date: date,
  //       time: time,
  //       timeFinished: '',
  //     );

  //     log('PEDIDO - ${order.toString()}');
  //     await _orderServices.createOrder(order);

  //     reset();
  //     homeController.selectedIndex = 0;

  //     log('Depois do reset');

  //     sucesso = true;
  //   } on Exception catch (e, s) {
  //     _loading.value = false;
  //     log('Número inválido', error: e, stackTrace: s);
  //     _message(
  //       MessageModel(
  //         title: 'Erro',
  //         message: 'Formato de número inválido. Tente novamente!',
  //         type: MessageType.error,
  //       ),
  //     );
  //     throw Exception('Número inválido');
  //   } catch (e, s) {
  //     _loading.value = false;
  //     log('Erro ao carregar produtos no carrinho', error: e, stackTrace: s);
  //     _message(
  //       MessageModel(
  //         title: 'Erro',
  //         message: 'Erro ao carregar produtos no carrinho',
  //         type: MessageType.error,
  //       ),
  //     );
  //     return false;
  //   } finally {
  //     log('TESTE FINALIZADO');
  //     _loading.value = false;
  //     log('Status do loading FINAL: ${loading.value}');
  //     isProcessing.value = false;
  //   }

  //   if (sucesso) {
  //     await 500.milliseconds.delay();
  //     _message(
  //       MessageModel(
  //         title: 'Pedido feito com sucesso',
  //         message: 'Seu pedido foi enviado e está sendo preparado!',
  //         type: MessageType.info,
  //       ),
  //     );
  //     return true;
  //   }
  //   // return sucesso;
  // }
}
