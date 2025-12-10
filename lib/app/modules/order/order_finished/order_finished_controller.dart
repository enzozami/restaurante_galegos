import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';

class OrderFinishedController extends GetxController with LoaderMixin, MessagesMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> listOrders;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    listOrders = firestore.collection('orders').where('status', isEqualTo: 'entregue').snapshots();
  }
}
