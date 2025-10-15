import 'package:flutter/material.dart';

class ListShoppingCard extends StatelessWidget {
  const ListShoppingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Text('TESte');
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 90,
    );
  }
}
