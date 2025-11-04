import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
        // log('${controller.onGeneratedRoute(const RouteSettings())}');
        return Visibility(
          visible: controller.isAdmin != true,
          replacement: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white60,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.black,
            // onTap: (index) => controller.selectedIndex = index,
            onTap: (index) {
              // log('Índice selecionado: $index');
              controller.selectedIndex = index;
            },
            currentIndex: controller.selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Pedidos'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Finalizados',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: 'Produto'),
              BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Marmitas'),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white60,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.black,
            // onTap: (index) => controller.selectedIndex = index,
            onTap: (index) {
              // log('Índice selecionado: $index');
              controller.selectedIndex = index;
            },
            currentIndex: controller.selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: 'Produto'),
              BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Marmitas'),
              BottomNavigationBarItem(
                icon: IconBadge(
                  icon: Icons.shopping_cart_outlined,
                  number: controller.totalProducts,
                ),
                label: 'Carrinho',
              ),
            ],
          ),
        );
      }),
      body:
          // log('Navigator key: ${HomeController.NAVIGATOR_KEY}');
          Navigator(
        initialRoute: (controller.isAdmin) ? '/allOrders' : '/products',
        key: Get.nestedKey(HomeController.NAVIGATOR_KEY),
        onGenerateRoute: controller.onGeneratedRoute,
      ),
    );
  }
}
