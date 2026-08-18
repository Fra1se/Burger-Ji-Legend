import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'route_observer.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
//...packages

import 'models/navigation_key.dart';
import 'providers/advertisements.dart';
import 'providers/order_data.dart';
import 'providers/cart_data.dart';
import 'providers/product_data.dart';
import 'providers/product_category_data.dart';
import 'providers/restaurant_data.dart';
import 'providers/my_orders_data.dart';
import 'providers/variations.dart';
//...providers

import 'screens/direct_payment_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/address_form_screen.dart';
import 'screens/order_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_screen.dart';
import 'screens/product_category_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/main_location_screen.dart';
import 'screens/qr_code_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/privacy_policy_screen.dart';
//...screens

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await Permission.manageExternalStorage.isDenied.then((value) {
    if (value) {
      Permission.manageExternalStorage.request();
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final ctx = NavigationService.navigatorKey.currentState!.overlay!.context;
    if (ctx.mounted) {
      final player = AudioPlayer();
      player.play(AssetSource('positive-notification-sound.wav'));
      
      showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          title: Text(message.notification?.title ?? 'Notification'),
          content: Text(message.notification?.body ?? 'You have a new message.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Advertisements(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MyOrders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Restaurants(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Carts(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final myOrders = Provider.of<MyOrders>(context, listen: false);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        myOrders.notify();
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        myOrders.notify();
      },
    );

    Future<dynamic> receiveItems() async {
      final adv = Provider.of<Advertisements>(context, listen: false);
      final myOrders = Provider.of<MyOrders>(context, listen: false);
      final res = Provider.of<Restaurants>(context, listen: false);

      await adv.receiveItems().catchError((error) {});
      await myOrders.receiveMyOrders().catchError((error) {});
      await res.receiveItems().catchError((error) {});
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductCategories(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Variations(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.teal,
            onPrimary: const Color(0xFF000000),
            primaryContainer: Colors.teal.shade400,
            onPrimaryContainer: const Color(0xFF000000),
            secondary: const Color(0xFF3996FF),
            onSecondary: const Color(0xFF000000),
            //...
            surface: const Color(0xFFffffff),
            onSurface: const Color(0xFF000000),
            surfaceContainer: const Color(0xFFF0F0F0),
            onSurfaceVariant: const Color(0xFF000000),
            //...
            shadow: const Color(0xFF3E3E3E),
            error: const Color(0xFFFF2146),

            onError: const Color(0xFFffffff),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                const Color(0xFF3996FF),
              ),
            ),
          ),
          //...AppBar
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFffffff),
            elevation: 2,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        home: FutureBuilder(
          future: receiveItems(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return const TabsScreen();
          },
        ),
        navigatorObservers: [AdRouteObserver(context)],
        routes: {
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          ProductCategoryScreen.routeName: (ctx) => const ProductCategoryScreen(),
          ProductScreen.routeName: (ctx) => const ProductScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (ctx) => const OrderScreen(),
          AddressFormScreen.routeName: (ctx) => const AddressFormScreen(),
          OrderHistoryScreen.routeName: (ctx) => const OrderHistoryScreen(),
          MainLocationScreen.routeName: (ctx) => const MainLocationScreen(),
          PaymentScreen.routeName: (ctx) => const PaymentScreen(),
          DirectPaymentScreen.routeName: (ctx) => const DirectPaymentScreen(),
          QrCodeScreen.routeName: (ctx) => const QrCodeScreen(),
          TermsScreen.routeName: (ctx) => const TermsScreen(),
          PrivacyPolicyScreen.routeName: (ctx) => const PrivacyPolicyScreen(),
        },
      ),
    );
  }
}
