import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository.dart';

import './order_finished_services.dart';

class OrderFinishedServicesImpl implements OrderFinishedServices {
  final OrderFinishedRepository _orderFinishedRepository;

  OrderFinishedServicesImpl({
    required OrderFinishedRepository orderFinishedRepository,
  }) : _orderFinishedRepository = orderFinishedRepository;

  @override
  Future<OrderFinishedModel> orderFinished(PedidoModel pedido) =>
      _orderFinishedRepository.orderFinished(pedido);

  @override
  Future<void> changeStatus(PedidoModel pedido) => _orderFinishedRepository.changeStatus(pedido);
}
