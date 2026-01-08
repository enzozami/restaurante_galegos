import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './add_lunchboxes_controller.dart';

class AddLunchboxesPage extends GetView<AddLunchboxesController> {
  const AddLunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddLunchboxesPage'),
      ),
      body: Container(),
    );
  }
}
