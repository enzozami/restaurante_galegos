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
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Pedidos',
            ),
            NavigationDestination(
              icon: Icon(Icons.motorcycle, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Entrega',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Finalizados',
            ),
            NavigationDestination(
              icon: Icon(Icons.lunch_dining, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Produto',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Marmitas',
            ),
          ];
        } else {
          destinations = [
            NavigationDestination(
              icon: Icon(Icons.lunch_dining, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Produto',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Marmitas',
            ),
            NavigationDestination(
              icon: IconBadge(
                icon: Icons.shopping_cart_outlined,
                number: controller.totalProducts,
                color: GalegosUiDefaut.colorScheme.primary,
              ),
              label: 'Carrinho',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long, color: GalegosUiDefaut.colorScheme.primary),
              label: 'Pedidos',
            ),
          ];
        }
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          child: NavigationBar(
            backgroundColor: GalegosUiDefaut.theme.navigationBarTheme.backgroundColor,
            indicatorColor: GalegosUiDefaut.theme.navigationBarTheme.indicatorColor,
            labelTextStyle: GalegosUiDefaut.theme.navigationBarTheme.labelTextStyle,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (value) => controller.selectedIndex = value,
            destinations: destinations,
          ),
        );
      }),
      body: Obx(() {
        return Center(child: controller.pages[controller.selectedIndex]);
      }),
    );
  }
}
