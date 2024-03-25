import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFadlSheet() {
  Get.bottomSheet(const FadlBottomSheet());
  // showModalBottomSheet(
  //   context: context,
  //   builder: (context) => const FadlBottomSheet(),
  // );
}

class FadlBottomSheet extends StatelessWidget {
  const FadlBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return ListView(children: const [
          Text(
              'daasddddddasdakjlsdjaklscnklasncklansdklnaklscjnakljscnakljcnklasnckljasncklancklacta',
              style: TextStyle(fontSize: 150)),
        ]);
      },
    );
  }
}
