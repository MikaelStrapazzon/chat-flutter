import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const DefaultAppBar(
      {Key? key, required this.title, this.showBackButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color(0xFF6750A4),
      automaticallyImplyLeading: false,
      centerTitle: true,
      foregroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back)
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
