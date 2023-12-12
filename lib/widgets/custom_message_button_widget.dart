import 'package:flutter/material.dart';

class MessageWithButtonWidget extends StatelessWidget {
  const MessageWithButtonWidget({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onTap,
  });

  final String title;
  final String buttonText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: onTap,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
