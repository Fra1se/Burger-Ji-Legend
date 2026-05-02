import 'package:flutter/material.dart';
//...packages

class IconRow extends StatelessWidget {
  const IconRow({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buttonBuilder(
      IconData icon,
      String title,
      void Function() onPressed,
    ) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SizedBox(
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Ink(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: const CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 25,
                  icon: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  padding: const EdgeInsets.all(0),
                  onPressed: onPressed,
                ),
              ),
              const SizedBox(height: 3),
              GestureDetector(
                onTap: onPressed,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
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

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 13,
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          children: [
            buttonBuilder(
              Icons.my_location,
              'Location',
              showAlert,
            ),
            buttonBuilder(
              Icons.article,
              'News',
              showAlert,
            ),
            buttonBuilder(
              Icons.event,
              'Events',
              showAlert,
            ),
            buttonBuilder(
              Icons.shopping_bag,
              'Promo',
              showAlert,
            ),
          ],
        ),
      ),
    );
  }
}
