import 'package:flutter/material.dart';

class RoundAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 20;
  final String title;

  const RoundAppBar({super.key, required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + barHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text(title)),
      ),
      centerTitle: true, // Center the title horizontally
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(48.0),
        ),
      ),
      actions: const [],
    );
  }
}
