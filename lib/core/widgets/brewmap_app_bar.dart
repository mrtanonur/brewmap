import 'package:flutter/material.dart';

class BrewmapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final bool hasLeading;
  const BrewmapAppBar({
    super.key,
    required this.title,
    required this.color,
    required this.hasLeading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: hasLeading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Text(title),
      backgroundColor: color,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
