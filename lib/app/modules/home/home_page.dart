import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_drawer.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/icon_badge.dart';
import './home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      drawer: GalegosDrawer(),
      bottomNavigationBar: Obx(() {
        List<NavigationDestination> destinations;
        if (controller.isAdmin) {
          destinations = [
            NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Pedidos'),
            NavigationDestination(icon: Icon(Icons.motorcycle), label: 'Entrega'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Finalizados'),
            NavigationDestination(icon: Icon(Icons.lunch_dining), label: 'Produto'),
            NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Marmitas'),
          ];
        } else {
          destinations = [
            NavigationDestination(icon: Icon(Icons.lunch_dining), label: 'Produto'),
            NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Marmitas'),
            NavigationDestination(
              icon: IconBadge(icon: Icons.shopping_cart_outlined, number: controller.totalProducts),
              label: 'Carrinho',
            ),
            NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
          ];
        }
        return NavigationBar(
          backgroundColor: GalegosUiDefaut.theme.navigationBarTheme.backgroundColor,
          indicatorColor: GalegosUiDefaut.theme.navigationBarTheme.indicatorColor,
          labelTextStyle: GalegosUiDefaut.theme.navigationBarTheme.labelTextStyle,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: controller.selectedIndex,
          onDestinationSelected: (value) => controller.selectedIndex = value,
          destinations: destinations,
        );
      }),
      body: Obx(() {
        return Center(child: controller.pages[controller.selectedIndex]);
      }),
    );
  }
}
