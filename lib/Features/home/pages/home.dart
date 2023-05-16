import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/weather-service.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showGetPositionButton = true;
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
      print(e.toString());
    }
  }

  void initState() {
    _getCurrentLocation();
    super.initState();
  }

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
              widget.username,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            if (_isLoadingWeatherData)
              CircularProgressIndicator()
            else if (_weatherData != null)
              Column(
                children: [
                  Text(
                    '${_weatherData!['location']['name']}, ${_weatherData!['location']['country']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${_weatherData!['current']['condition']['text']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Image.network(
                    'https:' + _weatherData!['current']['condition']['icon'],
                    scale: 1.0,
                    width: 64.0,
                    height: 64.0,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${_weatherData!['current']['temp_c']}°C',
                    style: TextStyle(fontSize: 48),
                  ),
                ],
              )
            else
              Text(
                'Tap the button to get your current location',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
