import 'package:flutter/material.dart';
import 'package:student_hub/utils/color_util.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final Color backgroundColor;
  final IconData? iconButton;
  final void Function()? onPressed;
  // 'isBack' is called when you want to back to the previous screen
  // and then, 'isBack' should follow with the context of current screen
  final bool isBack;
  final BuildContext currentContext;

  const CustomAppbar({
    super.key,
    required this.onPressed,
    required this.currentContext,
    this.title = 'StudentHub',
    this.iconButton = Icons.person, // initialize the icon of appbar
    this.isBack = false, // when a screen is a independent screen
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        backgroundColor = ColorUtil.darkPrimary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leadingWidth: 30.0,
        leading: isBack
            ? IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(currentContext),
              )
            : null,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconButton,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
