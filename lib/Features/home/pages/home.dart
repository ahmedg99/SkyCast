import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/Core/colors.dart';

import '../services/weather-service.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingWeatherData = true;
  Map<String, dynamic>? _weatherData;

  void _getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      var weatherData =
          await getWeatherData(position.latitude, position.longitude);
      setState(() {
        _weatherData = weatherData;
        _isLoadingWeatherData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingWeatherData = false;
      });
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors().secondaryColor,
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              if (_isLoadingWeatherData)
                const CircularProgressIndicator()
              else if (_weatherData != null)
                Column(
                  children: [
                    Text(
                      '${_weatherData!['location']['name']}, ${_weatherData!['location']['country']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_weatherData!['current']['condition']['text']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      'https:' + _weatherData!['current']['condition']['icon'],
                      scale: 1.0,
                      width: 64.0,
                      height: 64.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_weatherData!['current']['temp_c']}°C',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ],
                )
              else
                const Text(
                  'Tap the button to get your current location',
                  style: TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150, // Set the desired height here
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                ),
                child: Center(child: Text('Welcome ${widget.username}')),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
