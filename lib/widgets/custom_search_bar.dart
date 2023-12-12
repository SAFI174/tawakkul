import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      required this.onChanged,
      required this.hintText,
      this.searchText = ''});
  final Function(String) onChanged;
  final String hintText;
  final String searchText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: searchText),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FluentIcons.search_24_filled,
        ),
        hintStyle: const TextStyle(fontSize: 14),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        filled: true,

        // Use a transparent background
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding
      ),
    );
  }
}
