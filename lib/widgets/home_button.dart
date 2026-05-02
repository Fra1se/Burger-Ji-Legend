import 'package:flutter/material.dart';
//...packages

import '../screens/tabs_screen.dart';
//...screens

class HomeButton extends StatelessWidget {
  const HomeButton({ super.key });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false),
      icon: const Icon(Icons.home_rounded),
    );
  }
}