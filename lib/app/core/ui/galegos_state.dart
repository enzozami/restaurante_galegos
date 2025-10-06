import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class GalegosState<S extends StatefulWidget, C extends GetxController> extends State<S> {
  C get controller => Get.find();
}
