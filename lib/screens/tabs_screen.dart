import 'package:burger_ji_legend/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/my_orders_data.dart';
import '../providers/cart_data.dart';
//...providers

import 'product_category_screen.dart';
import 'my_orders_screen.dart';
import 'main_location_screen.dart';
import 'vouchers_screen.dart';
import 'points_screen.dart';
//...screens

import '../widgets/cart_button.dart';
import '../widgets/main_drawer.dart';
//...widgets

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  static const routeName = '/tab-screen';

  @override
  TabsScreenState createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  List<Map> _screens = [];
  int _selectedScreenIndex = 0;
  //...

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  void initState() {
    _screens = [
      {
        'screen': const RestaurantScreen(),
        'title': 'Burger Ji Legend',
      },
      {
        'screen': const PointsScreen(),
        'title': 'Points',
      },
      {
        'screen': const VouchersScreen(),
        'title': 'Vouchers',
      },
      {
        'screen': const MyOrdersScreen(),
        'title': 'My Orders',
      },
    ];

    final carts = Provider.of<Carts>(context, listen: false);
    if (carts.isInit) {
      carts.receiveItems(context);
      carts.isInit = false;
    }
    super.initState();
  }

  //...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            _screens[_selectedScreenIndex]['title'],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(MainLocationScreen.routeName);
            },
          ),
          const CartButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
          size: 25,
        ),
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
          size: 25,
        ),
        onTap: (index) {
          _selectScreen(index);
        },
        currentIndex: _selectedScreenIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Main',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.loyalty,
            ),
            label: 'Points',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.card_giftcard,
            ),
            label: 'Vouchers',
          ),
          BottomNavigationBarItem(
            icon: Consumer<MyOrders>(
              builder: (ctx, myOrders, ch) {
                return Badge(
                  isLabelVisible: myOrders.badgeItems != 0,
                  label: Text(myOrders.badgeItems.toString()),
                  child: const Icon(
                    Icons.alarm,
                  ),
                );
              },
            ),
            label: 'My Orders',
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Click Again to Exit'),
          duration: Duration(seconds: 3),
        ),
        child: _screens[_selectedScreenIndex]['screen'],
      ),
    );
  }
}
