import 'package:flutter/material.dart';

class GalegosAppBar extends AppBar {
  GalegosAppBar({super.key})
      : super(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Image.network(
            'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
            width: 150,
          ),
        );
}
