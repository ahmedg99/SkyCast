import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              username,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var permission = await Geolocator.checkPermission();
                  print("persiossion ::::$permission");
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission != LocationPermission.whileInUse &&
                        permission != LocationPermission.always) {
                      // Handle the case where the user denied location permission
                      // You can display an error message or prompt the user to grant permission
                      return;
                    }
                  }
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);

                  print(position);
                },
                child: Text("get position"))
          ],
        ),
      ),
    );
  }
}
