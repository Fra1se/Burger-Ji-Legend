import 'package:flutter/material.dart';
//...packages

import '../screens/privacy_policy_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/terms_screen.dart';
//...screens

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tileBuilder({
      required IconData icon,
      required String title,
      required void Function() onTap,
    }) {
      return ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        onTap: () {
          onTap();
        },
      );
    }

    void showAlert() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Currently Not Available'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    //...

    return Drawer(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            tileBuilder(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                showAlert();
              },
            ),
            tileBuilder(
              icon: Icons.account_box,
              title: 'Profile',
              onTap: () {
                showAlert();
              },
            ),
            tileBuilder(
              icon: Icons.history,
              title: 'Order History',
              onTap: () {
                Navigator.of(context).pushNamed(OrderHistoryScreen.routeName);
              },
            ),
            tileBuilder(
              icon: Icons.policy,
              title: 'Terms & Conditions',
              onTap: () {
                Navigator.of(context).pushNamed(TermsScreen.routeName);
              },
            ),
            tileBuilder(
              icon: Icons.policy,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
