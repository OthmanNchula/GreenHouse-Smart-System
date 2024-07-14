import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context, {required String title}) {
  return AppBar(
    title: Text(title),
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
  );
}