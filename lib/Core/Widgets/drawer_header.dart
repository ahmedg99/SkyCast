import 'package:flutter/material.dart';

Widget builderHeader(BuildContext context, String username) {
  return Center(
    child: Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/profil.jpg'),
        ),
        Text(
          "Welcome $username",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
