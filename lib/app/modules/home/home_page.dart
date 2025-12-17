import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_drawer.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/icon_badge.dart';

import './home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GalegosAppBar(
        context: context,
      ),
      drawer: GalegosDrawer(),
      bottomNavigationBar: Obx(() {
        List<NavigationDestination> destinations;
        if (controller.isAdmin) {
          destinations = [
            NavigationDestination(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: theme.colorScheme.primary,
              ),
              label: 'Pedidos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.motorcycle,
                color: theme.colorScheme.primary,
              ),
              label: 'Entregas',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: theme.colorScheme.primary,
              ),
              label: 'Finalizados',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.lunch_dining,
                color: theme.colorScheme.primary,
              ),
              label: 'Produtos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.restaurant_menu,
                color: theme.colorScheme.primary,
              ),
              label: 'Marmitas',
            ),
          ];
        } else {
          destinations = [
            NavigationDestination(
              icon: Icon(
                Icons.lunch_dining,
                color: theme.colorScheme.primary,
              ),
              label: 'Produtos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.restaurant_menu,
                color: theme.colorScheme.primary,
              ),
              label: 'Marmitas',
            ),
            NavigationDestination(
              icon: IconBadge(
                icon: Icons.shopping_cart_outlined,
                number: controller.totalProducts,
                color: theme.colorScheme.primary,
              ),
              label: 'Carrinho',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.receipt_long,
                color: theme.colorScheme.primary,
              ),
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
            backgroundColor: theme.navigationBarTheme.backgroundColor,
            indicatorColor: theme.navigationBarTheme.indicatorColor,
            labelTextStyle: theme.navigationBarTheme.labelTextStyle,
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
