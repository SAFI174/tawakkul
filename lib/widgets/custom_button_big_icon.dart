import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButtonBigIcon extends StatelessWidget {
  const CustomButtonBigIcon(
      {super.key,
      required this.text,
      required this.iconData,
      required this.onTap});
  final String text;
  final IconData iconData;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Theme.of(context).disabledColor.withAlpha(40),
        ),
      ),
      width: 100,
      height: 200,
      child: Material(
        type: MaterialType.canvas,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                iconData,
                size: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: AutoSizeText(
                  text,
                  minFontSize: 5,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
