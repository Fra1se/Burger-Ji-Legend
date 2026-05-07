import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/restaurant_data.dart';
//...providers

class MainLocationScreen extends StatefulWidget {
  const MainLocationScreen({super.key});

  static const routeName = '/main-location';

  @override
  State<MainLocationScreen> createState() => _MainLocationScreenState();
}

class _MainLocationScreenState extends State<MainLocationScreen> {
  @override
  Widget build(BuildContext context) {
    final scrollBarController = ScrollController();

    final res = Provider.of<Restaurants>(context);
    final resItems = res.items;

    void launchURL(String url) async {
      if (!await launchUrl(
        Uri.parse(url),
      )) {
        throw 'Could not launch $url';
      }
    }
    //...

    Widget buttonBuilder(
      IconData icon,
      String title,
      String? url,
    ) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 25,
        ),
        child: SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            icon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 18,
            ),
            label: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 13,
              ),
            ),
            onPressed: url == null ? null : () => launchURL(url),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: RawScrollbar(
        controller: scrollBarController,
        thickness: 5,
        thumbColor: Theme.of(context).colorScheme.secondary,
        radius: const Radius.circular(5),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollBarController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.network(
                  'resItems.restaurantMapImg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'resItems.restaurantTitle',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //Text(resItems.address['addressLine']),
                      const SizedBox(height: 20),
                      const Text('Map'),
                      GestureDetector(
                        onTap: () => launchURL('resItems.googleMapLink'),
                        child: Text(
                          'resItems.googleMapLink',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              buttonBuilder(
                Icons.phone,
                'Call Us',
                'tel:${'resItems.rawNumber'}',
              ),
              buttonBuilder(
                Icons.email,
                'Email Us',
                'mailto:${'resItems.email'}',
              ),
              buttonBuilder(
                FontAwesomeIcons.whatsapp,
                'WhatsApp',
                'whatsapp://send?&phone=${'resItems.whatsApp'}',
              ),
              // buttonBuilder(
              //   FontAwesomeIcons.facebook,
              //   'Facebook',
              //   null,
              // ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
