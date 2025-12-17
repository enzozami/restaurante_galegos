import 'package:flutter/material.dart';

class GalegosAppBar extends AppBar {
  GalegosAppBar({super.key, Widget? icon, required BuildContext context})
    : super(
        elevation: Theme.of(context).appBarTheme.elevation,
        scrolledUnderElevation: Theme.of(
          context,
        ).appBarTheme.scrolledUnderElevation,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        centerTitle: true,
        toolbarHeight: kToolbarHeight + 20,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset('assets/splash/splash_logo_dark.png', width: 90),
        ),
        actions: [icon ?? SizedBox.shrink()],
      );
}
