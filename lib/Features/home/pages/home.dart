import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/Core/string_manager/colors.dart';
import 'package:skycast/Features/Authentication/pages/login.dart';
import '../../../Core/Widgets/drawer_header.dart';
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
          children: [
            SizedBox(
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                ),
                child: builderHeader(context, widget.username),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Profil'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
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
